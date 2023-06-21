# SSTORE/SLOAD report


| Method                 | Contract        | Reads | Writes | Comment                                                                  |
|------------------------|-----------------|-------|--------|--------------------------------------------------------------------------|
| BatchBurnNonSequential | DemoERC1155     |  100  |   100  |                                                                          |
|                        | DemoERC721      |  500  |   300  |                                                                          |
|                        | DemoERC721A     |  799  |   400  |                                                                          |
|                        | DemoERC721AOptT |   0   |    0   | Not tested, as for batch burn `ERC721ABatchBurnable` extension is used   |
|                        | DemoERC721AOptB |  401  |   301  |                                                                          |


| Method                 | Contract        | Reads | Writes | Comment                                                                  |
|------------------------|-----------------|-------|--------|--------------------------------------------------------------------------|
| BatchBurnSequential    | DemoERC1155     |  100  |   100  |                                                                          |
|                        | DemoERC721      |  500  |   300  |                                                                          |
|                        | DemoERC721A     |  700  |   399  |                                                                          |
|                        | DemoERC721AOptT |   0   |    0   | Not tested, as for batch burn `ERC721ABatchBurnable` extension is used   |
|                        | DemoERC721AOptB |  103  |    3   |                                                                          |


| Method                 | Contract        | Reads | Writes | Comment                                                                  |
|------------------------|-----------------|-------|--------|--------------------------------------------------------------------------|
| BatchMint              | DemoERC1155     |  100  |   100  |                                                                          |
|                        | DemoERC721      |  400  |   200  |                                                                          |
|                        | DemoERC721A     |   2   |    3   |                                                                          |
|                        | DemoERC721AOptT |   0   |    0   | Not tested, as the results would be the same as for `ERC721A`            |
|                        | DemoERC721AOptB |   0   |    0   | Not tested, as the results would be the same as for `ERC721A`            |


| Method                     | Contract        | Reads | Writes | Comment                                                                    |
|----------------------------|-----------------|-------|--------|----------------------------------------------------------------------------|
| BatchTransferNonSequential | DemoERC1155     |  200  |   200  |                                                                            |
|                            | DemoERC721      |  600  |   400  |                                                                            |
|                            | DemoERC721A     |  799  |   400  |                                                                            |
|                            | DemoERC721AOptT |  402  |   202  |                                                                            |
|                            | DemoERC721AOptB |   0   |    0   | Not tested, as for batch burn `ERC721ABatchTransferable` extension is used |

| Method                     | Contract        | Reads | Writes | Comment                                                                    |
|----------------------------|-----------------|-------|--------|----------------------------------------------------------------------------|
| BatchTransferSequential    | DemoERC1155     |  200  |   200  |                                                                            |
|                            | DemoERC721      |  600  |   400  |                                                                            |
|                            | DemoERC721A     |  700  |   399  |                                                                            |
|                            | DemoERC721AOptT |  203  |    3   |                                                                            |
|                            | DemoERC721AOptB |   0   |    0   | Not tested, as for batch burn `ERC721ABatchTransferable` extension is used |


| Method                 | Contract        | Reads | Writes | Comment                                                                  |
|------------------------|-----------------|-------|--------|--------------------------------------------------------------------------|
| SingleBurn             | DemoERC1155     |   1   |    1   |                                                                          |
|                        | DemoERC721      |   5   |    3   |                                                                          |
|                        | DemoERC721A     |   5   |    3   |                                                                          |
|                        | DemoERC721AOptT |   0   |    0   | Not tested, as for batch burn `ERC721ABatchBurnable` extension is used   |
|                        | DemoERC721AOptB |   4   |    3   |                                                                          |


| Method                 | Contract        | Reads | Writes | Comment                                                                  |
|------------------------|-----------------|-------|--------|--------------------------------------------------------------------------|
| SingleMint             | DemoERC1155     |   1   |    1   |                                                                          |
|                        | DemoERC721      |   4   |    2   |                                                                          |
|                        | DemoERC721A     |   2   |    3   |                                                                          |
|                        | DemoERC721AOptT |   0   |    0   | Not tested, as the results would be the same as for `ERC721A`            |
|                        | DemoERC721AOptB |   0   |    0   | Not tested, as the results would be the same as for `ERC721A`            |


| Method                 | Contract        | Reads | Writes | Comment                                                                    |
|------------------------|-----------------|-------|--------|----------------------------------------------------------------------------|
| SingleTransfer         | DemoERC1155     |   2   |    2   |                                                                            |
|                        | DemoERC721      |   6   |    4   |                                                                            |
|                        | DemoERC721A     |   5   |    3   |                                                                            |
|                        | DemoERC721AOptT |   4   |    3   | Not tested, as the results would be the same as for `ERC721A`              |
|                        | DemoERC721AOptB |   0   |    0   | Not tested, as for batch burn `ERC721ABatchTransferable` extension is used |


# Gas Report

| src/DemoERC1155.sol:DemoERC1155 contract |                 |         |         |         |         |
|------------------------------------------|-----------------|---------|---------|---------|---------|
| Deployment Cost                          | Deployment Size |         |         |         |         |
| 1388227                                  | 7294            |         |         |         |         |
| Function Name                            | min             | avg     | median  | max     | # calls |
| batchBurn                                | 297236          | 297236  | 297236  | 297236  | 2       |
| batchMint                                | 2345466         | 3282048 | 2345466 | 4686921 | 5       |
| batchTransfer                            | 2093472         | 2093472 | 2093472 | 2093472 | 2       |
| singleBurn                               | 3144            | 3144    | 3144    | 3144    | 1       |
| singleMint                               | 25955           | 25955   | 25955   | 25955   | 3       |
| singleTransfer                           | 21176           | 21176   | 21176   | 21176   | 1       |


| src/DemoERC721.sol:DemoERC721 contract |                 |         |         |         |         |
|----------------------------------------|-----------------|---------|---------|---------|---------|
| Deployment Cost                        | Deployment Size |         |         |         |         |
| 1151290                                | 6036            |         |         |         |         |
| Function Name                          | min             | avg     | median  | max     | # calls |
| batchBurn                              | 433739          | 433739  | 433739  | 433739  | 2       |
| batchMint                              | 2520853         | 3520173 | 2520853 | 5019153 | 5       |
| batchTransfer                          | 586775          | 596725  | 596725  | 606675  | 2       |
| singleBurn                             | 4457            | 4457    | 4457    | 4457    | 1       |
| singleMint                             | 47185           | 47185   | 47185   | 47185   | 3       |
| singleTransfer                         | 22400           | 22400   | 22400   | 22400   | 1       |


| src/DemoERC721A.sol:DemoERC721A contract |                 |         |         |         |         |
|------------------------------------------|-----------------|---------|---------|---------|---------|
| Deployment Cost                          | Deployment Size |         |         |         |         |
| 977117                                   | 5161            |         |         |         |         |
| Function Name                            | min             | avg     | median  | max     | # calls |
| batchBurn                                | 2795798         | 3900478 | 3900478 | 5005159 | 2       |
| batchMint                                | 263620          | 342260  | 263620  | 460220  | 5       |
| batchTransfer                            | 2813900         | 3918580 | 3918580 | 5023261 | 2       |
| singleBurn                               | 27592           | 27592   | 27592   | 27592   | 1       |
| singleMint                               | 69007           | 69007   | 69007   | 69007   | 3       |
| singleTransfer                           | 27897           | 27897   | 27897   | 27897   | 1       |


| src/DemoERC721AOptB.sol:DemoERC721AOptB contract |                 |         |         |         |         |
|--------------------------------------------------|-----------------|---------|---------|---------|---------|
| Deployment Cost                                  | Deployment Size |         |         |         |         |
| 1123456                                          | 5877            |         |         |         |         |
| Function Name                                    | min             | avg     | median  | max     | # calls |
| batchBurnNonSequential                           | 4768459         | 4768459 | 4768459 | 4768459 | 1       |
| batchBurnSequential                              | 457977          | 457977  | 457977  | 457977  | 1       |
| batchMint                                        | 263374          | 361524  | 361524  | 459674  | 2       |
| singleBurn                                       | 27500           | 27500   | 27500   | 27500   | 1       |
| singleMint                                       | 68925           | 68925   | 68925   | 68925   | 1       |


| src/DemoERC721AOptT.sol:DemoERC721AOptT contract |                 |         |         |         |         |
|--------------------------------------------------|-----------------|---------|---------|---------|---------|
| Deployment Cost                                  | Deployment Size |         |         |         |         |
| 1155089                                          | 6035            |         |         |         |         |
| Function Name                                    | min             | avg     | median  | max     | # calls |
| batchMint                                        | 260074          | 356574  | 356574  | 453074  | 2       |
| batchTransferNonSequential                       | 4956169         | 4956169 | 4956169 | 4956169 | 1       |
| batchTransferSequential                          | 679556          | 679556  | 679556  | 679556  | 1       |
| singleMint                                       | 68981           | 68981   | 68981   | 68981   | 1       |
| singleTransfer                                   | 27916           | 27916   | 27916   | 27916   | 1       |
