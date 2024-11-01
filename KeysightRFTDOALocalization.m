% Define the filename
filename = '3.15.24.2Dickerson.csv';

% Read the data from the CSV file without using the headers
data = readtable(filename, 'ReadVariableNames', false);

% Manually set the column names to match your data
data.Properties.VariableNames = {'MeasID', 'Algorithm', 'CenterFrequency', 'SampleRate', ...
                                 'NumSamples', 'Latitude', 'Longitude', 'Elevation', ...
                                 'RHO', 'CEP', 'TotalSensors', 'ValidSensors', ...
                                 'OverloadedSensors', 'SensorNames', 'Time', 'Comment'};

% If a location estimate is not generated, lat and long = 0.
% The following line parses out these values.
rows_to_delete = data.Latitude < 1;
data(rows_to_delete, :) = [];

% Reinitialize data table variables
Measurement_ID = data.MeasID;
Algorithm = data.Algorithm;
Center_Frequency = data.CenterFrequency;
Sample_Rate = data.SampleRate;
Number_of_Samples = data.NumSamples;
Latitude = data.Latitude;
Longitude = data.Longitude;
Elevation = data.Elevation;
Rho = data.RHO;
CEP = data.CEP;
Total_Sensors = data.TotalSensors;
Valid_Sensors = data.ValidSensors;
Overloaded_Sensors = data.OverloadedSensors;
Sensor_Names = data.SensorNames;
Time = data.Time;
Comment = data.Comment;

% Real coordinates for LW1
LW1lat = 35.72750947;
LW1long = -78.69595810;

% Real coordinates for LW2 - one of three towers used to generate
% localization estimate
LW2lat = 35.72821305;
LW2long = -78.70090823;

% Real coordinates for LW3 - one of three towers used to generate
% localization estimate
LW3lat = 35.72491205;
LW3long = -78.69190014;

% Real coordinates for LW4 - one of three towers used to generate
% localization estimate
LW4lat = 35.73318358;
LW4long = -78.6983642;

% Plot on map using Mapping Toolbox
figure;
geoplot(Latitude, Longitude, 'bo');
title('Keysight Sensor Management Tool TDOA Localization of AERPAW LW1');
hold on;
geoplot(LW1lat, LW1long, 'r^', 'MarkerSize', 10); % LW1
geoplot(LW2lat, LW2long, 'g^', 'MarkerSize', 10); % LW2
geoplot(LW3lat, LW3long, 'b^', 'MarkerSize', 10); % LW3
geoplot(LW4lat, LW4long, 'm^', 'MarkerSize', 10); % LW4
legend('TDOA Estimated TX Coordinates', 'AERPAW LW1', 'AERPAW LW2', 'AERPAW LW3', 'AERPAW LW4');
hold off;

% Distance between LW1 and estimated coordinate points in meters
% (localization error)
localizationerror = deg2km(distance(LW1lat, LW1long, Latitude, Longitude)) * 1000;

% Average localization error
average_error = mean(localizationerror);

% Normalize the first time index to 0
normalized_time = Time - Time(1);

% Create a new figure for the second plot
figure;

% Plot localization error against time
plot(normalized_time, localizationerror, 'bo-');
title('SMT TDOA Localization Error vs. Time');
xlabel('Time (Hours:Minutes:Seconds)');
ylabel('Localization Error (meters)');
