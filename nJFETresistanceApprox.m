function Z = nJFETresistanceApprox(Vgs, Vds)
    %% Copyright (C) 2024 Riccardo Giampiccolo
    %
    % Permission is hereby granted, free of charge, to any person obtaining a copy
    % of this software and associated documentation files (the "Software"), to deal
    % in the Software without restriction, including without limitation the rights
    % to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    % copies of the Software, and to permit persons to whom the Software is
    % furnished to do so, subject to the following conditions:
    %
    % The above copyright notice and this permission notice shall be included in
    % all copies or substantial portions of the Software.
    %
    % THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    % IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    % FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    % AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    % LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    % OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    % THE SOFTWARE.

    Is0 = 5.367e-3; % 2N5952 saturation current at zero gate-source voltage
    Vp = -2.021; % 2N5952 pinch-off voltage
    k = 2 * Is0 / Vp^2; % auxiliary parameter
    lambda = 4e-3; % 2N5952 Early effect parameter

    if Vgs - Vp < 0
    
            Z = 1e12;
            
    else 
        if Vds <= Vgs - Vp

            Z = 1 / (k * (Vgs - Vp - Vds/2) );
    
        else 
        
            Z = Vds / (Is0*(1 - Vgs/Vp)^2*(1 + lambda*Vds));

        end
        
    end

end