function testSplit = getTestData(allData, testStartIndex, testEndIndex)

    testHeaders = ["rightEye", "leftEye"];
    testDirections = ["X","Y", "Radius", "Found"];
    col = 1;
    for i = 1:length(testHeaders)
        for j = 1:length(testDirections)
            if (testDirections(j)) == "Found"
                testSplit.(testHeaders(i)).(testDirections(j)) = logical(allData(testStartIndex:testEndIndex, col));
            else
                testSplit.(testHeaders(i)).(testDirections(j)) = allData(testStartIndex:testEndIndex, col);
    %             figure()
    %             plot(allData(testStartIndex:testEndIndex, col))
    %             title(testHeaders(i) + testDirections(j))
            end
            col = col + 1;
        end
    end
end