n=2;R=1;
%[v, f]=icosahedron();
%[v, f]=spheretri(n)
[v, f]=spheretribydepth(n);
[X, Y, indicesOfBadPairs] = mollweide(v,1);
figure;hold('on');
for k=1:length(f)                                                                              % Loop through all faces of the polyhedron
    for j=1:2                                                                                  % Loop through the first two vertices of the face
        if indicesOfBadPairs(f(k,j), f(k,j+1)) == 1                                            % This pair of vertices is not supposed to be connected by an edge in the Mollweide plot because it crosses the whole figure (like a line from Alaska to Eastern Russia would despite them being geographically close)
            if j == 1;f(k,1) = nan;                                                            % Remove the first vertex of the face if j=1 (i.e. the edge between the first two vertices of the face is bad)
            else f(k,3) = nan; end                                                             % Remove the third vertex of the face if j=2 (i.e. the edge between the last two vertices of the face is bad)
        end
    end
    if isnan(f(k,1)); if ~isnan(f(k,3)); plot(X(f(k,2:3)),Y(f(k,2:3)),'k','LineWidth',2); end  % If vertex 1 of face k was removed, then only plot the edge betwen vertex 2 and vertex 3 if vertex 3 is not also removed.
    elseif isnan(f(k,3));                plot(X(f(k,1:2)),Y(f(k,1:2)),'k','LineWidth',2);      % If vertex 1 of face k was not removed, then only plot the edge between vertex 1 and vertex 2 if vertex 3 is removed.
    else;                                plot(X(f(k,:)),Y(f(k,:)),'k','LineWidth',2);          % If neither vertex 1 nor vertex 3 were removed, the plot the edge between vertex 1 and 2, and the edge between vertex 2 and 3.
    end
end
