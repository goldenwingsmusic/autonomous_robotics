function plotSensors( h )


sensors = kProximity(h);
for i = 1:8
            sensor_value = ((-0.96*log(sensors(i))-0.1)+4)+4;
            if (sensor_value>3.5)
                    sensor_value = 0;
            end
                normalized_sensors(i) = sensor_value;
                graph = bar(normalized_sensors);
                drawnow;     
                delete(graph);
            end
            h ='ploting';
end

