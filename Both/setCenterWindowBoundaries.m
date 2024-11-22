function startAndEnd = setCenterWindowBoundaries(currentPoint, startAndEnd, mouseButton) 
    if startAndEnd(1) < 2
        % First click - move start point
        startAndEnd(1) = currentPoint;
    else
        % It is not the first click
        if currentPoint < startAndEnd(1)  
            % Click is left of the start point - move start point
            startAndEnd(1) = currentPoint;
        elseif currentPoint < startAndEnd(2)
            % Click is right of end point - move end point 
            startAndEnd(2) = currentPoint;
        else
            if mouseButton == 1
                % Left click - set start point
                startAndEnd(1) = currentPoint;
            elseif mouseButton == 3
                % Right click - set end point
                startAndEnd(2) = currentPoint;
            else
                % Not right or left click, do nothing
            end
        end
    end

    if startAndEnd(1) > startAndEnd(2)
        startAndEnd = flip(startAndEnd);
    end
end