family = 'TRACIR';
names = {'X-00469'};
group = HebiLookup.newGroupFromNames(family, names);
cmd = CommandStruct();
t0 = tic(); T_poke = 5;T_retract = 5;T_wait = 5;
start_pos = -0.7
end_pos = 0.4
slope =  (end_pos-start_pos)/T_poke; count = 1;
    while(toc(t0)<T_poke)
    fbk = group.getNextFeedback();
    t = toc(t0);
    p = slope*t + start_pos
 
    cmd.position = p;
%     cmd.velocity = cos( w * t ) * w;
    group.send(cmd);
     force(count) = fbk.effort(1);
     count = count+1;
    pause(0.01);
    
    end
while(toc(t0)<T_poke+T_wait)
    fbk = group.getNextFeedback();
     force(count) = fbk.effort(1);
     count = count+1;
     pause(0.01);
end
temp = start_pos;
start_pos = end_pos;
end_pos = -0.7;
slope =  (end_pos-start_pos)/T_retract;

 while( toc(t0)<T_poke+T_retract+T_wait)
fbk = group.getNextFeedback();
    t2 = toc(t0)-T_poke-T_wait;
    p = slope*t2 + start_pos
 
    cmd.position = p;
%     cmd.velocity = cos( w * t ) * w;
    group.send(cmd);
    force(count) = fbk.effort(1);
     count = count+1;
    pause(0.01);
 end

plot(force,'LineWidth',4)