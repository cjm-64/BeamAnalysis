function testSplit = getTestData(allData, testStartIndex, testEndIndex)

    testHeaders = ["rightEye_X", "rightEye_Y", "leftEye_X", "leftEye_Y"];
    for i = 1:4
        testSplit.(testHeaders(i)) = allData(testStartIndex:testEndIndex, i);
    end
end