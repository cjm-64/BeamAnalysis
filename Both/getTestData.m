function testSplit = getTestData(allData, testStartIndex, testEndIndex)

    testHeaders = ["rightEye", "leftEye"];
    testDirections = ["X","Y"];
    col = 1;
    for i = 1:2
        for j = 1:2
            testSplit.(testHeaders(i)).(testDirections(j)) = allData(testStartIndex:testEndIndex, col);
            col = col + 1;
        end
    end
end