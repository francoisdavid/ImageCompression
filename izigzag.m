% Modified from https://www.mathworks.com/matlabcentral/fileexchange/15317-zigzag-scan?focused=6119314&tab=function
% Alexey S. Sokolov a.k.a. nICKEL, Moscow, Russia
% June 2007
% alex.nickel@gmail.com
function output = izigzag(in, vmax, hmax)
h = 1;
v = 1;
output = zeros(vmax, hmax);
i = 1;
while ((v <= vmax) & (h <= hmax))
    if (mod(h + v, 2) == 0)                % going up
        if (v == 1)
            output(v, h) = in(i);
            if (h == hmax)
	      v = v + 1;
	    else
              h = h + 1;
            end;
            i = i + 1;
        elseif ((h == hmax) & (v < vmax))
            output(v, h) = in(i);
            i;
            v = v + 1;
            i = i + 1;
        elseif ((v > 1) & (h < hmax))
            output(v, h) = in(i);
            v = v - 1;
            h = h + 1;
            i = i + 1;
        end;
        
    else                                   % going down
       if ((v == vmax) & (h <= hmax))
            output(v, h) = in(i);
            h = h + 1;
            i = i + 1;
        
       elseif (h == 1)
            output(v, h) = in(i);
            if (v == vmax)
	      h = h + 1;
	    else
              v = v + 1;
            end;
            i = i + 1;
       elseif ((v < vmax) & (h > 1))
            output(v, h) = in(i);
            v = v + 1;
            h = h - 1;
            i = i + 1;
        end;
    end;
    if ((v == vmax) & (h == hmax))
        output(v, h) = in(i);
        break
    end;
end;