"Minthelper" is an experiment in writing a contract that would handle minting w/ auto-donation, with the goal of increasing gas usage efficiency
on the Ethereum or Ethereum-alike network while Solo mining is being performed.
I opted for a simple transfer() call to the ERC918 token contract's transfer() function instead. To my recollection, this contract likely
does not work, but may be useful to revise/reuse at some point.
-LtTofu
