for i = 1:1
%     figure(1)
%     plot(offsets(4,:, i), offsets(1,:,i))
%     hold on
%     title('Left')
% 
%     figure(2)
%     plot(offsets(4,:, i), offsets(2,:,i))
%     hold on
%     title('Right')
% 
%     figure(3)
%     plot(offsets(4,:, i), offsets(3,:,i))
%     hold on
%     title('Diff')

    figure()
    plot(offsets(4,4:6, i), offsets(2,4:6,i))
    hold on
    title('Right w/ Left Cal')

    figure()
    plot(offsets(4,1:3, i), offsets(1,1:3,i))
    hold on
    title('Left w/ Righ Cal')
end