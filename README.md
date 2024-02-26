# Wave Digital Model of the MXR Phase 90 based on a Time-Varying Resistor Approximation of JFET Elements

This repository is meant as a companion page for the paper **Wave Digital Model of the MXR Phase 90 based on a Time-Varying Resistor Approximation of JFET Elements**, authored by R. Giampiccolo, S. Del Moro, C. Eutizi, M. Massimi, O. Massi, and A. Bernardini.

**Abstract**: Virtual Analog (VA) modeling is the practice of digitally emulating analog audio gear. Over the past few years, with the purpose of recreating the alleged distinctive sound of audio equipment and musicians, many different guitar pedals have been emulated by means of the VA paradigm, but a little attention has been given to phasers. Phasers process the spectrum of the input signal with time-varying notches by means of shifting stages typically realized with a network of transistors, whose nonlinear equations are, in general, demanding to be solved. In this paper, we take as a reference the famous MXR Phase 90 guitar pedal, and we propose an efficient time-varying model of its Junction Field-Effect Transistors (JFETs) based on a channel resistance approximation. We then employ such a model in the Wave Digital domain to emulate in real-time the guitar pedal, obtaining an implementation characterized by low computational cost and good accuracy.  

## Plug-in
We build and freely provide a plug-in of the WDF-based MXR Phase 90. Both the Windows (VST) and MacOS (AU, VST) installers can be downloaded from this [link](https://polimi365-my.sharepoint.com/:f:/g/personal/10454432_polimi_it/EhHosFs0sgtAslKdPNava3UByncijOgON74aRMW7okpHSw?e=q9Ynss). The plug-in is build using the [JUCE framework](https://juce.com).

