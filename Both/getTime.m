function timeVector = getTime(headers, timeVectorLength)
    timeHeader = headers(length(headers));
    timeHeadersSplit = split(timeHeader,"_");
    testMinutes = str2num(timeHeadersSplit(length(timeHeadersSplit)));
    testHours = str2num(timeHeadersSplit(length(timeHeadersSplit)-1));

    timeVector = linspace(0,(testHours * 60 * 60) + (testMinutes * 60), timeVectorLength);
end
