import numpy as np
import matplotlib.pyplot as plt

def fourier_analysis(dataset,dt):
	fft = (np.fft.fft(dataset)/len(dataset))
	N = len(dataset)
	f = np.linspace(0, 1 /( 2*dt), N/2)
	freqs = np.fft.fftfreq(len(dataset),dt)
	# print((freqs),freqs.max())
	return(f,fft,freqs)

def inverse_fourier(x,freq):
    if (abs(freq)>25 and abs(freq)<35):
        return x
    else:
        return x
         
