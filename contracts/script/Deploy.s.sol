// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "forge-std/Script.sol";
import "../src/ERC8183.sol";
import "../src/AtomicHandoverHook.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor() ERC20("MockToken", "MTK") {
        _mint(msg.sender, 1000000 * 10**18);
    }
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envOr("PRIVATE_KEY", uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80));
        vm.startBroadcast(deployerPrivateKey);

        MockToken token = new MockToken();
        console.log("MockToken deployed to:", address(token));

        ERC8183 erc8183 = new ERC8183(address(token));
        console.log("ERC8183 deployed to:", address(erc8183));

        AtomicHandoverHook hook = new AtomicHandoverHook(address(token), address(erc8183));
        console.log("AtomicHandoverHook deployed to:", address(hook));

        vm.stopBroadcast();
    }
}
