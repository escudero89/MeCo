function t = timingCal (text,time)

%% timing Evaluates and acumule the used time.
%
%  Parameters:
%
%    Input, text : String to show.
%           time : Accumulate time at t-1
%   
%    Output, t   : Accumulate time at t

  itim = toc;                         % Close previous tic
  fprintf(1,[text,' %12.6f \n'],itim);  % Output time and text
  t = itim + time;                    % Accumulate time in t
  
  tic                                 % Open an new tic
