function [X, Y, indicesOfBadPairs] =  mollweide(v,R)                                 % v = [x y z] where x,y,z are vectors. R is the radius

x = v(:,1); y = v(:,2); z = v(:,3);

phi   = atan2(y,x);                                               % Azimuth
theta = acos(z./sqrt(x.^2 + y.^2 + z.^2));                        % Polar angle
latitude = pi/2 - theta;                                          % phi from Wikipedia = pi/2 - theta = latitude.

tol = 1e-6;

for k=1:length(theta)
    f = @(a) 2*a + sin(2*a) - pi*sin(latitude(k));                % f = 2a + sin(2a) = pi*sin(pi/2 - theta) is the function we want to find the root of. theta is a constant and "a" is what we're trying to find.
    if (abs(latitude(k)-pi/2) < tol); a(k,1) = latitude(k);       % If |latitude(k) - pi/2| is close to 0, then it means we're at the North or South pole. Wikipedia says: (+/-)phi = pi/2  => (+/-)theta=pi/2 => skip the root-finding algorithm.
    else
        a(k,1) = fzero(f,latitude(k));                            % find the angle "a" where the function "f" is 0. Use "a = latitude(k)" as the intial guess.
    end
end

Y = R*sqrt(2)*sin(a);                                             % a = the theta in https://en.wikipedia.org/w/index.php?title=Mollweide_projection&oldid=1073635466
X = R*2*sqrt(2)*cos(a).*phi/pi;                                   % (lambda - lamdba0)/pi = phi/pi. lamdda0=0; lambda=phi.

indicesOfBadPairs=abs(phi.'-phi)>pi;                              % If |phi(i)-phi(j)| > pi (i.e. the longitudes differ by more than pi), then indicesOfBadPairs(i,j) = 1, meaning that we don't want to draw an edge between such vertices, because they will go across the whole figure (just like a line between Alaska and Eastern Russia despite them being close geographically).
