# Wave Digital Model of the MXR Phase 90 based on a Time-Varying Resistor Approximation of JFET Elements

This repository is meant as a companion page for the paper **Wave Digital Model of the MXR Phase 90 based on a Time-Varying Resistor Approximation of JFET Elements**, authored by R. Giampiccolo, S. Del Moro, C. Eutizi, M. Massimi, O. Massi, and A. Bernardini.

**Abstract**: Virtual Analog (VA) modeling is the practice of digitally emulating analog audio gear. Over the past few years, with the purpose of recreating the alleged distinctive sound of audio equipment and musicians, many different guitar pedals have been emulated by means of the VA paradigm, but a little attention has been given to phasers. Phasers process the spectrum of the input signal with time-varying notches by means of shifting stages typically realized with a network of transistors, whose nonlinear equations are, in general, demanding to be solved. In this paper, we take as a reference the famous MXR Phase 90 guitar pedal, and we propose an efficient time-varying model of its Junction Field-Effect Transistors (JFETs) based on a channel resistance approximation. We then employ such a model in the Wave Digital domain to emulate in real-time the guitar pedal, obtaining an implementation characterized by low computational cost and good accuracy.  

## Files

The repository includes the following main files:

- `main.m`: Main MATLAB script for emulation of the MXR Phase 90 in the Wave Digital domain.
- `nJFETresistanceApprox.m`: MATLAB function implementing the proposed time-varying approximation of nJFET elements.
- `LTspice/MXRphase90.asc`: LTspice schematic of the MXR Phase 90. You can download the freeware software at this [link](https://www.analog.com/en/design-center/design-tools-and-calculators/ltspice-simulator.html). Both Windows and macOS are available.
- `LTspice/LFO.txt`: File containing the LFO points used inside LTspice for the simulation of the circuit.
- `LTspice/standard.bjt`: Library containig different models of BJTs, including the 2N4125 used in the MXR Phase 90 circuit.
- `LTspice/standard.jft`: Library containig different models of JFETs, including the 2N5952 used in the MXR Phase 90 circuit.

## Usage

To utilize this code, clone the repository and execute `main.m` in MATLAB. You can also simulate the circuit using the files in the `LTspice` folder: copy and paste these files inside the main LTspice directory on your computer.

## Plug-in
We build and freely provide a plug-in of the WDF-based MXR Phase 90. Both the Windows (VST) and MacOS (AU, VST) installers can be downloaded from this [link](https://polimi365-my.sharepoint.com/:f:/g/personal/10454432_polimi_it/EhHosFs0sgtAslKdPNava3UByncijOgON74aRMW7okpHSw?e=q9Ynss). The plug-in is build using the [JUCE framework](https://juce.com).

