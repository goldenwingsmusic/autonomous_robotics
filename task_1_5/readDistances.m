function readDistances(h)

global distances;

distances = zeros(8,1);

sensors = kProximity(h);
    for i = 1:8       
           v = (sensors(i)-30)/(3970);
           if v <= 0
            sensor_value = 8;
           else
            sensor_value = (-0.96*log(v)-0.1);
           end
           distance(i) = abs(sensor_value);                
    end
    distances = distance;
end