function testDataRawClipped = clipRawData(rawData)
    names = fieldnames(rawData);    
    for name = 1:numel(names)
        if names(name) == "fps"
            testDataRawClipped.fps = rawData.fps;
        elseif names(name) == "time"
            testDataRawClipped.time = rawData.time(120*rawData.fps:end-120*rawData.fps);
        else
            directions = fieldnames(rawData.(names{name}));
            for dir = 1:numel(directions)
                testDataRawClipped.(names{name}).(directions{dir}) = rawData.(names{name}).(directions{dir})(120*rawData.fps:end-120*rawData.fps);
            end
        end
    end
end