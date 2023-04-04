# GSM-covid19CL
 <!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/neurovisionhub/GSM-covid19CL">
    <img src="images/logobiobio.png" alt="Logo" width="80" height="80">
    <img src="images/logo_usach.png" alt="Logo" width="80" height="80">
    <img src="images/logouchile.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">A general modeling framework for quantitative tracking, accurate prediction of ICU, and assessing vaccination for COVID-19 in Chile</h3>

  <p align="center">
    Patricio Cumsille (U. Bío-Bío), Oscar Rojas (U. Santiago de Chile) and Carlos Conca (U. de Chile)
    <br />
    <a href="https://github.com/neurovisionhub/GSM-covid19CL"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/neurovisionhub/GSM-covid19CL/blob/main/main.m">main</a>
  </p>
</p>

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#run">run</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
   <ul>
        <li><a href="#run">main configuration</a></li>
        <li><a href="#data">Official data</a></li>
      </ul>    
    <li><a href="#contributing">Contributing</a></li>
     <li><a href="#Author-contributions">Author contributions</a></li> 
      <li><a href="#license">License</a></li>
 <!--   <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>-->
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

Background: One of the main lessons of the COVID-19 pandemic is that we must prepare to face another pandemic like it. Consequently, this article aims to develop a general framework consisting of epidemiological modeling and a practical identifiability approach to assess combined vaccination and non-pharmaceutical intervention (NPI) strategies for the dynamics of any transmissible disease.

Materials and methods: Epidemiological modeling of the present work relies on delay differential equations describing time variation and transitions between suitable compartments. The practical identifiability approach relies on parameter optimization, a parametric bootstrap technique, and data processing. We implemented a careful parameter optimization algorithm by searching for suitable initialization according to each processed dataset. In addition, we implemented a parametric bootstrap technique to accurately predict the ICU curve trend in the medium term and assess vaccination.

Results: We show the framework's calibration capabilities for several processed COVID-19 datasets of different regions of Chile. We found a unique range of parameters that works well for every dataset and provides overall numerical stability and convergence for parameter optimization. Consequently, the framework produces outstanding results concerning quantitative tracking of COVID-19 dynamics. In addition, it allows us to accurately predict the ICU curve trend in the medium term and assess vaccination. Finally, it is reproducible since we provide open-source codes that consider parameter initialization standardized for every dataset.

Conclusion: This work attempts to implement a holistic and general modeling framework for quantitative tracking of the dynamics of any transmissible disease, focusing on accurately predicting the ICU curve trend in the medium term and assessing vaccination. The scientific community could adapt it to evaluate the impact of combined vaccination and NPIs strategies for COVID-19 or any transmissible disease in any country and help visualize the potential effects of implemented plans by policymakers. In future work, we want to improve the computational cost of the parametric bootstrap technique or use another more efficient technique. The aim would be to reconstruct epidemiological curves to predict the combined NPIs and vaccination policies' impact on the ICU curve trend in real-time, providing scientific evidence to help anticipate policymakers' decisions.
<p align="center">
<a href="https://doi.org/10.3389/fpubh.2023.1111641">https://doi.org/10.3389/fpubh.2023.1111641</a>
  </p>
### run 

* open file ./main.m and run with matlab 

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites
matlab 2014 or higher

* https://la.mathworks.com/products/matlab.html 

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/neurovisionhub/GSM-covid19CL.git
   ```
2. cd directory
   ```sh 
   cd ./GSM-covid19CL
   ```
<!-- USAGE EXAMPLES -->
## Usage
In root folder, edit "main.m" to run predefined experiments, where 'test_paper_build_tables.m' loads the experimental data and params.
   ```sh
clear
addpath(genpath('./'))
```

### data

Official data from the Chilean Ministry of Science repository, available at https://github.com/MinCiencia/Datos-COVID19 

## Contributing
<!-- CONTRIBUTING -->

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.
<!-- CONFLICT OF INTEREST STATEMENT -->
The authors declare that the research was conducted without commercial or financial relationships that could constitute a potential conflict of interest.

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact

O. Rojas - oscar.rojas.d@usach.cl

Project Link: [https://github.com/neurovisionhub/GSM-covid19CL](https://github.com/neurovisionhub/GSM-covid19CL)](https://github.com/neurovisionhub/GSM-covid19CL)

## Author contributions
<!-- AUTHOR CONTRIBUTIONS -->

- Collaborative research
  - Department of Basic Sciences, Faculty of Sciences, University of Bío-Bío (P. Cumsille).
  - Department of Mathematics and Computer Science, Faculty of Science, University of Santiago of Chile (O. Rojas).
  - Department of Mathematical Engineering (DIM) and Center for Mathematical Modeling (CMM), University of Chile (C. Conca).
  - Centre for Biotechnology and Bioengineering (CeBiB), University of Chile (C. Conca and P. Cumsille).

PC contributed to conceptualization, formal analysis, investigation, methodology, project administration, software, supervision, validation, writing – original draft, writing review & editing.

ORD contributed to conceptualization, formal analysis, investigation, methodology, software, validation, writing – review & editing.

CC contributed to supervision, writing - review & editing.

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
Funding 

The Centre for Biotechnology and Bioengineering (CeBiB), Grant Number ANID PFBasal-01, partially supported PC and CC. In addition, PC was partially supported by the regular research project DIUBB 2120432 IF/R. Finally, CC was partially supported by the ACE210010 and CMM PIA AFB170001 projects. The funders had no role in study design, data collection, analysis, publication decision, or manuscript preparation. 

<!-- 
<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

