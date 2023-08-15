data = load ('KML_maker.mat');

lat = rad2deg(data.lla_pos(:,1));
lon = rad2deg(data.lla_pos(:,2));
alt =         data.lla_pos(:,3) ;

fileID = fopen('kml_part.txt','w');

formatSpec = '%2.8f,%2.8f,%3.4f\n';
for ii = 1:length(data.time)
    fprintf(fileID,formatSpec,lon(ii),lat(ii),alt(ii));  
end

