function [ distances ] = readDistances(h)

sensors = kProximity(h);
    for i = 1:8
           if sensors(i) <= 80
               sensor_value = 0;
           elseif sensors(i) >= 4000
               sensor_value = (-0.96*log(1))-0.1;
           elseif sensors(i) > 80 && sensors(i) <4000
               v = sensors(i)/(3920);
               sensor_value = (-0.96*log(v))-0.1;
           end

           distances(i) = abs(sensor_value);                
    end
end