import hebi
from math import pi, sin
from time import sleep, time

lookup = hebi.Lookup()
# print(lookup.entrylist)
# Wait 2 seconds for the module list to populate
sleep(2.0)

family_name = "TRACIR"
module_name = "X-00469"

T_poke = 5;T_wait = 5;T_retract = 5;
start_pos = -1.7
end_pos = -0.4
slope =  (end_pos-start_pos)/T_poke; count = 1;

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
t = time() - start

while t < T_poke:
  # Even though we don't use the feedback, getting feedback conveniently
  # limits the loop rate to the feedback frequency
  group.get_next_feedback(reuse_fbk=group_feedback)
  t = time() - start

  
  p = slope*t + start_pos
  group_command.position = p
  print(p)
  group.send_command(group_command)
  sleep(0.01)
t = time() - start
while(t<T_poke+T_wait):
	t = time() - start
	group.get_next_feedback(reuse_fbk=group_feedback)
	# force(count) = fbk.effort(1);
	count = count+1;
	sleep(0.01)
print('Hello')
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
	group_command.position = p
  	print(p)
  	group.send_command(group_command)
	sleep(0.01)
# # Stop logging. `log_file` contains the contents of the file
# log_file = group.stop_log()