# ECG Signal Denoising using EMD (Empirical Mode Decomposition)

This project demonstrates how to denoise an ECG (electrocardiogram) signal using **Empirical Mode Decomposition (EMD)**. The method decomposes the noisy signal into Intrinsic Mode Functions (IMFs) and reconstructs a cleaner version by removing the noise-dominant IMFs.

---

## 📌 Overview

- **Input**: Clean ECG signal + simulated Gaussian noise (SNR = 10 dB)
- **Process**:
  - Perform EMD to extract IMFs
  - Discard the first few IMFs (assumed to capture high-frequency noise)
  - Reconstruct the denoised signal from the remaining IMFs
- **Output**: Denoised ECG signal

---

## 📁 Files Included

| File            | Description                                       |
|-----------------|---------------------------------------------------|
| `m103.mat`      | Sample ECG data (MIT-BIH record)                  |
| `emd.m`         | Custom MATLAB implementation of EMD              |
| `test_emd.m` | Main script to load, process, and denoise ECG     |
| `README.md`     | This documentation                                |

---

## 📈 Sample Plots

- Original clean ECG signal  
- Noisy ECG signal (with Gaussian noise)  
- Denoised ECG signal after removing first N IMFs  
- All IMFs visualized

---

## 🧪 How It Works

### 1. Load and Preprocess Signal
```matlab
load('m103.mat');
ecg_sig = val(1:T*Fs) - 1024; % Remove baseline
