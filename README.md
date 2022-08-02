# AddressZero

Very bad things would happen if you could set `msg.sender` to `address(0)`
during actual execution. The Optimism bridge would be susceptible to attack.
The exploit is very simple, see `src/AddressZero.sol`.

Run the exploit like so:

```bash
$ forge script \
    -vvvvv src/AddressZero.sol \
    --tc AddressZero \
    --rpc-url <mainnet-url>
```
