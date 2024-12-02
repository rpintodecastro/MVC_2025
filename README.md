# MVC_2025
Repository of the 2025 IEEE VTS Motor Vehicle Challenge (MVC). Please refere to the [INSTALLATION.md](INSTALLATION.md) file for instruction about how to use the software and the necessary software requirements.

## Introduction
![VPPC2024_MVC2025_Fig01c](https://github.com/user-attachments/assets/3058258b-4cb9-44c9-a135-982c7fad2200)

The topic of the challenge is to develop an <mark>Energy Management System</mark> (EMS) for a tugboat application. The tugboat powertrain consists of a dual-three phase permanent magnet synchronous motor where each of the two three phase windings are fed by a three phase inverter. The power source of each inverter is different, that is the following two energy sources are employed:
* a battery pack (BP)
* a supercapacitor module (SM)


## Rules
The participants to the challenge will operate only in the EMS block provided within the simulation file. All the remaining blocks must not be modified. <ins>The final evaluation will be carried out by implementing the EMS block developed by each participant in the original simulation file</ins>. That is, <mark>all the modifications made in subsystems which are not the EMS one will be discarded</mark>. 

Important rules that the submitted proposal must satisfy for being considered valid in this competition:
1. all parameters defined in the "Parameters" folder can be used to develop the strategy.
2. All parameter defined in the "Reference" folder and "main_runSimulation.m" **cannot** be used to develop the strategy: the EMS **must not** adopt whatsoever a priori knowledge of the reference working cycle.
3. All parameters adopted for the developed strategy **must** be specified only in the "ProposedEMS.m" script.
4. Energy constraints of the BP and SM must always be guaranteed.

## Release Notes
Please refer to the [CHANGELOG.md](https://github.com/VTSociety/MVC_2025/blob/main/CHANGELOG.md) file for modifications of the simulation and differences with respect to the paper in the [Bibliography](), that is [10.1109/VPPC63154.2024.10755298](https://ieeexplore.ieee.org/document/10755298) ([preprint version here](Materials)).

Remarks:
* Please take notice of the [Discussion board](https://github.com/VTSociety/MVC_2025/discussions) for Q&A. Start a new discussion if you've found no answer to your issue. No answers will be given to questions related the MVC 2025 by private emails.

## Bibliography
M. Porru, A. Serpi, F. Tinazzi and L. Ortombina, "IEEE VTS Motor Vehicle Challenge 2025 – Energy Management and Control of a Marine Electric Propulsion System," 2024 IEEE Vehicle Power and Propulsion Conference (VPPC), Washington, DC, USA, 2024, pp. 1-6, doi: [10.1109/VPPC63154.2024.10755298](https://ieeexplore.ieee.org/document/10755298).

## License
All files of the repository "MVC 2025" are intended solely for the aim of the Motor Vehicle Challenge competition organised within the IEEE VTS Society. The Authors declined all responsabilities for usage outside this context. 

Copyright © 2024-2025. The code is released under the [CC BY-NC 4.0 license](https://creativecommons.org/licenses/by-nc/4.0/legalcode). Link to [short summary of CC BY-NC 4.0 license](https://creativecommons.org/licenses/by-nc/4.0/). For attribution see also [license file](LICENSE.md).


