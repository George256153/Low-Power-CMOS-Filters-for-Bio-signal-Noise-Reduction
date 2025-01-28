# Low-Power-CMOS-Filters-for-Bio-signal-Noise-Reduction

## Overview
This project focuses on the design and simulation of a switched-capacitor filter system tailored for bio-signal noise reduction. By employing advanced filtering techniques, the system effectively suppresses noise while preserving the fidelity of the original signal. This work demonstrates the potential of low-power and high-efficiency designs in biomedical signal processing.

---
## System Architecture
![System Architecture](path/to/your/diagram.png)

This diagram illustrates the filter's architecture, including the notch filters, Chebyshev I low-pass filter, and operational amplifier integration.

## Key Features
- **Filter Design**: A 4th-order Chebyshev I low-pass filter combined with targeted notch filters for precise noise suppression.
- **Low Power**: Utilization of a telescopic operational amplifier in subthreshold operation to minimize power consumption.
- **Compact Circuitry**: Replacement of resistive components with switched-capacitor circuits to reduce circuit area without compromising performance.
- **High Performance**: Achieves significant noise reduction at specific frequencies (3 Hz and 342 Hz) while maintaining high signal integrity.

---

## System Architecture
1. **Filter Stages**:
   - **Notch Filters**: Suppress noise at 3 Hz and 342 Hz.
   - **Chebyshev I Low-pass Filter**: Ensures effective attenuation of high-frequency noise.
2. **Operational Amplifier**:
   - Telescopic structure for low power consumption.
   - Unity-gain bandwidth: 119 kHz.
   - DC gain: 77 dB.
   - Phase margin: 90°.
3. **Switched-Capacitor Circuits**:
   - Replace high-value resistors to minimize area and power usage.
   - Non-overlapping clock circuits to prevent short circuits and improve stability.

---

## Simulation Results
- **Error Value**: Achieved a minimum error of 42.04, demonstrating excellent noise suppression and signal preservation.
- **Power Efficiency**: Most power consumption is attributed to the switched-capacitor circuits, with opportunities for further optimization.
- **Performance Metrics**:
  - Stable operation with low power consumption.
  - Effective attenuation at target frequencies.

---

## Tools and Technology
- **Development Tools**: HSPICE, MATLAB.
- **Fabrication Process**: 0.18 μm CMOS technology.

---

## Future Work
1. Replace the 3 Hz notch filter with a high-pass filter to reduce low-frequency errors.
2. Optimize the delay of the non-overlapped clock circuit for enhanced performance.
3. Further improve the operational amplifier design to lower power consumption and enhance circuit stability.

---

## References
1. Chia-Ling Wei, *Special Topics on Integrated Circuits Design* (Course Material), NCKU.
2. R. Schaumann and M.E. Van Valkenburg, *Design of Analog Filters*, Oxford, 2010.
3. B. Razavi, *Design of Analog Integrated Circuits*, McGraw-Hill, 2001.
4. S. Franco, *Design with Operational Amplifiers and Analog Integrated Circuits*, 3rd Edition, McGraw-Hill, 2002.

---

## Author
**Chun-Chi Lu**  
Email: [Your Email Address]  
LinkedIn: [Your LinkedIn Profile]  

---

## How to Use
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo-url.git
