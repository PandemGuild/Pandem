import { createPublicClient, createWalletClient, http, parseUnits, parseEventLogs, keccak256, toHex } from 'viem'
import { baseSepolia } from 'viem/chains'
import { privateKeyToAccount } from 'viem/accounts'
import fs from 'fs'

const ERC8183_ARTIFACT = JSON.parse(fs.readFileSync("../contracts/out/ERC8183.sol/ERC8183.json", "utf8"));
const HOOK_ARTIFACT = JSON.parse(fs.readFileSync("../contracts/out/AtomicHandoverHook.sol/AtomicHandoverHook.json", "utf8"));
const MOCK_TOKEN_COMPILED = JSON.parse(fs.readFileSync("../contracts/out/AtomicHandoverHook.t.sol/MockToken.json", "utf8"));

const PRIVATE_KEY = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
const accountDeployer = privateKeyToAccount(PRIVATE_KEY);

const publicClient = createPublicClient({
  chain: baseSepolia,
  transport: http('https://sepolia.base.org')
});

const deployerClient = createWalletClient({
    account: accountDeployer,
    chain: baseSepolia,
    transport: http('https://sepolia.base.org')
});

const BUDGET = parseUnits("100", 6);
const COLLATERAL = parseUnits("50", 6);
const DELIVERABLE_HASH = keccak256(toHex("ipfs://BaseSepoliaEncryptedPayload"));
const REASON_APPROVED = keccak256(toHex("APPROVED"));

async function getNonce() {
    return await publicClient.getTransactionCount({ address: accountDeployer.address, blockTag: 'pending' });
}

async function runTestnetDeployment() {
    let balance = await publicClient.getBalance({ address: accountDeployer.address });
    console.log(`Found ETH! Balance: ${balance.toString()} wei. Proceeding with deployment...`);

    let nonce = await getNonce();
    console.log(`Initial nonce: ${nonce}`);

    console.log("\n=== 1. DEPLOYING CONTRACTS ON BASE SEPOLIA ===");

    const tokenHash = await deployerClient.deployContract({
        abi: MOCK_TOKEN_COMPILED.abi,
        bytecode: MOCK_TOKEN_COMPILED.bytecode.object,
        nonce: nonce++
    });
    console.log(`Deploying Mock USDC... Tx: ${tokenHash}`);
    const tokenReceipt = await publicClient.waitForTransactionReceipt({ hash: tokenHash });
    const tokenAddr = tokenReceipt.contractAddress;
    console.log(`Mock USDC Deployed: ${tokenAddr}`);

    const erc8183Hash = await deployerClient.deployContract({
        abi: ERC8183_ARTIFACT.abi,
        bytecode: ERC8183_ARTIFACT.bytecode.object,
        args: [tokenAddr],
        nonce: nonce++
    });
    console.log(`Deploying ERC8183... Tx: ${erc8183Hash}`);
    const erc8183Receipt = await publicClient.waitForTransactionReceipt({ hash: erc8183Hash });
    const erc8183Addr = erc8183Receipt.contractAddress;
    console.log(`ERC8183 Deployed: ${erc8183Addr}`);

    const hookHash = await deployerClient.deployContract({
        abi: HOOK_ARTIFACT.abi,
        bytecode: HOOK_ARTIFACT.bytecode.object,
        args: [tokenAddr, erc8183Addr],
        nonce: nonce++
    });
    console.log(`Deploying Hook... Tx: ${hookHash}`);
    const hookReceipt = await publicClient.waitForTransactionReceipt({ hash: hookHash });
    const hookAddr = hookReceipt.contractAddress;
    console.log(`AtomicHandoverHook Deployed: ${hookAddr}\n`);

    console.log("=== 2. MINTING AND APPROVING TOKENS ===");
    const mintHash = await deployerClient.writeContract({
        address: tokenAddr,
        abi: MOCK_TOKEN_COMPILED.abi,
        functionName: 'mint',
        args: [accountDeployer.address, parseUnits("1000", 6)],
        nonce: nonce++
    });
    await publicClient.waitForTransactionReceipt({ hash: mintHash });
    console.log("Minted 1000 pUSDC.");

    const maxUint256 = 115792089237316195423570985008687907853269984665640564039457584007913129639935n;
    const app1 = await deployerClient.writeContract({ address: tokenAddr, abi: MOCK_TOKEN_COMPILED.abi, functionName: 'approve', args: [erc8183Addr, maxUint256], nonce: nonce++ });
    await publicClient.waitForTransactionReceipt({ hash: app1 });
    console.log("Approved ERC8183");

    const app2 = await deployerClient.writeContract({ address: tokenAddr, abi: MOCK_TOKEN_COMPILED.abi, functionName: 'approve', args: [hookAddr, maxUint256], nonce: nonce++ });
    await publicClient.waitForTransactionReceipt({ hash: app2 });
    console.log("Approved Hook");

    console.log("Tokens approved to ERC8183 and Hook.");

    console.log("\n=== 3. JOB CREATION & FUNDING ===");
    const deadline = BigInt(Math.floor(Date.now() / 1000) + (7 * 24 * 60 * 60));

    const createHash = await deployerClient.writeContract({
        address: erc8183Addr,
        abi: ERC8183_ARTIFACT.abi,
        functionName: 'createJob',
        args: [accountDeployer.address, accountDeployer.address, deadline, "Fix Bug (Testnet)", hookAddr],
        nonce: nonce++
    });
    const createReceipt = await publicClient.waitForTransactionReceipt({ hash: createHash });

    const logs = parseEventLogs({ abi: ERC8183_ARTIFACT.abi, logs: createReceipt.logs, eventName: 'JobCreated' });
    const jobId = logs[0].args.jobId;
    console.log(`Job Created! ID: ${jobId}`);

    const bgHash = await deployerClient.writeContract({ address: erc8183Addr, abi: ERC8183_ARTIFACT.abi, functionName: 'setBudget', args: [jobId, BUDGET, "0x"], nonce: nonce++ });
    await publicClient.waitForTransactionReceipt({ hash: bgHash });

    const colHash = await deployerClient.writeContract({ address: hookAddr, abi: HOOK_ARTIFACT.abi, functionName: 'configureCollateral', args: [jobId, COLLATERAL], nonce: nonce++ });
    await publicClient.waitForTransactionReceipt({ hash: colHash });

    const fundHash = await deployerClient.writeContract({ address: erc8183Addr, abi: ERC8183_ARTIFACT.abi, functionName: 'fund', args: [jobId, BUDGET, "0x"], nonce: nonce++ });
    await publicClient.waitForTransactionReceipt({ hash: fundHash });
    console.log("Job Funded successfully.");

    console.log("\n=== 4. COMPLETION ===");
    const submitHash = await deployerClient.writeContract({ address: erc8183Addr, abi: ERC8183_ARTIFACT.abi, functionName: 'submit', args: [jobId, DELIVERABLE_HASH, "0x"], nonce: nonce++ });
    await publicClient.waitForTransactionReceipt({ hash: submitHash });

    const completeHash = await deployerClient.writeContract({ address: erc8183Addr, abi: ERC8183_ARTIFACT.abi, functionName: 'complete', args: [jobId, REASON_APPROVED, "0x"], nonce: nonce++ });
    const completeReceipt = await publicClient.waitForTransactionReceipt({ hash: completeHash });
    console.log("Job Completed!");

    const hookLogs = parseEventLogs({ abi: HOOK_ARTIFACT.abi, logs: completeReceipt.logs, eventName: 'PayloadReadyForDecryption' });
    if (hookLogs.length > 0) {
        console.log("🔓 PayloadReadyForDecryption Event Emitted on Base Sepolia!");
    }
}

runTestnetDeployment().catch(console.error);
