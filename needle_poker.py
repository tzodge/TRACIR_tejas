
import hebi
from math import pi, sin
from time import sleep, time
import matplotlib.pyplot as plt
import numpy as np
from fourier_analysis import *

file = "data_logger.txt"
f = open(file,'w')
f.close()
f = open(file,'a')
lookup = hebi.Lookup()
# print(lookup.entrylist)
# Wait 2 seconds for the module list to populate
sleep(2.0); alpha = 0.05;
force_needle = []; force_needle_uf = []; force_needle_f = [];
family_name = "TRACIR"
module_name = "X-00469"

T_poke = 5;T_wait = 5;T_retract = 5;
start_pos = 1.2
end_pos = 2
slope =  (end_pos-start_pos)/T_poke; count = 1;
ws = 10; #window size

group = lookup.get_group_from_names([family_name], [module_name])
# print(group)
if group is None:
  print('Group not found! Check that the family and name of a module on the network')
  print('matches what is given in the source file.')
  exit(1)

group_command  = hebi.GroupCommand(group.size)
group_feedback = hebi.GroupFeedback(group.size)

# # Start logging in the background
# group.start_log('logs')

# freq_hz = 0.5                 # [Hz]
# freq    = freq_hz * 2.0 * pi  # [rad / sec]
# amp     = pi * 0.25           # [rad] (45 degrees)

duration = 2.0               # [sec]
start = time()
t = time() - start; dt = 0.01
print('Inserting Needle')
pos_needle = 1.2
while t < T_poke:
  # Even though we don't use the feedback, getting feedback conveniently
  # limits the loop rate to the feedback frequency
  group.get_next_feedback(reuse_fbk=group_feedback)
  t = time() - start

  
  p = slope*t + start_pos
  group_command.velocity = slope
  #print(p)
  group.send_command(group_command)
  sleep(dt)
  pos_needle = group_feedback.position 
  force_needle.append(group_feedback.effort)
  force_needle_uf.append(group_feedback.effort)
  t = time() - start
while(t<T_poke+T_wait):
	t = time() - start
	group.get_next_feedback(reuse_fbk=group_feedback)
	# force(count) = fbk.effort(1);
        force_needle.append(group_feedback.effort)
        force_needle_uf.append(group_feedback.effort)

	count = count+1;
	sleep(dt)
print('Wait Over')
temp = start_pos;
start_pos = end_pos;
end_pos = temp;
slope =  (end_pos-start_pos)/T_retract;
t = time() - start

while( t<T_poke+T_retract+T_wait):
	t = time() - start
	group.get_next_feedback(reuse_fbk=group_feedback)
	t2 = t-T_poke-T_wait;
	p = slope*t2 + start_pos
	group_command.velocity = slope
  #	print(p)
  	group.send_command(group_command)
        force_needle.append(group_feedback.effort)
        force_needle_uf.append(group_feedback.effort)
	sleep(dt)

#plt.plot(force_needle)
#plt.show()

# # Stop logging. `log_file` contains the contents of the file
# log_file = group.stop_log()
#unfiltered_force  =  force_needle
#plt.plot(unfiltered_force)
for i in range(1,len(force_needle)):
	force_needle[i] =  force_needle[i-1] +alpha* (force_needle[i]-force_needle[i-1])
#	print('Filtering')
#plt.figure()
for k in range(0,len(force_needle_uf)-ws-1):
	#for j in range(ws):
#	print('Hello')
	force_needle_f.append(np.dot([0.1,0.05,0.05,0.05,0.25,0.25,0.05,0.05,0.05,0.1],force_needle_uf[k:k+ws])) 

plt.plot(force_needle_uf)
#plt.show
plt.plot(force_needle)
plt.title("Low Pass Filter", fontdict=None, loc='center', pad=None)

start_test = time(); A = [];
for test in range(0,100):
  t_test = time() - start_test
  A.append(np.sin(2*20 *np.pi * t_test) + 3*np.sin(2*10 *  np.pi * t_test)+ 20*np.sin(2*50 *  np.pi * t_test)+100*t_test)
  sleep(dt)

for i in range(0,400):
  f.write(str(force_needle_uf[i])+" "+'\n')
plt.figure()
dataset = force_needle_uf[0:400]
def normalize(dataset):
  N = len(dataset)
  mean_data = np.mean(dataset)
  # max_data = max(force_needle_uf[0:400])
  # min_data = min(force_needle_uf[0:400])
  for i in range(0,len(dataset)):
    dataset[i] = dataset[i]
  return dataset,N

A,N = normalize(A)

[f,fft,freqs] = fourier_analysis(A,dt)
# plt.plot(xf, 2.0/N * np.abs(fft[0:N/2]))
plt.ylabel("Amplitude")
plt.xlabel("Frequency [Hz]")
# plt.bar(f[:N // 2], np.abs(fft)[:N // 2] * 1 / N, width=1.5)  # 1 / N is a normalization factor
plt.plot(f, np.abs(fft[0:N/2]))

F_filtered = np.array([inverse_fourier(x,freq) for x,freq in zip(fft,freqs)])
 
# reconstruct the filtered signal
s_filtered = np.fft.ifft(fft)
plt.figure()
plt.plot(s_filtered)

plt.show()
f.close()