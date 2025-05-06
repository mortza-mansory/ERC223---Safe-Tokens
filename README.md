# ERC223---Safe-Tokens
A repo for mini to advanced ERC223 safe tokens

What is the difference between ERC-20 and ERC-223?
```
1. Lost Tokens Problem
ERC-20 is risky:
If you send tokens to a smart contract that is not ready to receive them, the tokens are lost forever. You cannot get them back.

ERC-223 is smart:
It checks if the receiver is a smart contract. If yes, it calls a special function (tokenFallback) on the contract.
If the contract cannot handle the token, the transfer stops. So, tokens are safe.

2. Less Gas Used
 In ERC-20, if you want to send tokens to a smart contract, you usually need two steps:
approve()
transferFrom()
 In ERC-223, you only need one transfer() — it saves gas and is simpler.

3. Send Data with Tokens
 ERC-223 lets you send extra data (like a note or message) with the token.
For example: “Here are 10 tokens to buy item #5.”
 ERC-20 does not support sending data.
```
- Mini Token
  You can send tokens to someone.
- Basic Token
  If the receiver is a contract, it can react (do something when it gets tokens).
- Intermediate Token
  Approve someone to spend your tokens.
  Burn tokens.
  Mint new tokens.
  Pause the token system if there’s danger.

  
