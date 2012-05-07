function pw = getpass(varargin)
%        getpass is a script for producing a randomized password given
%    common criteria as seen in all types of computer systems and software.
%            - Minimum/maximum password length
%            - Minimum number of uppercase, lowercase, numerical and special
%              characters
%            - User defined data sets
%
%        It includes a check to make sure all criteria are met.
%
%        Written by David Chandler (dchand10@jhu.edu) on 11/13/2006 as an
%    academic exercise and because no other program with such options seems
%    to exist, (Matlab or otherwise).
%

rand('twister', sum(100*clock));

% Edit these sets as needed
up = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M'...
      'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'];
low = ['a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm'...
       'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z'];
nums = ['0' '1' '2' '3' '4' '5' '6' '7' '8' '9'];
special = ['`' '~' '@' '#' '$' '&' '^' '(' ')' '+' '-' '=' '{' '}' '|' '[' ']' '\' ':' '”' ';' '<' '>' '?' ',' '.' '/']

pass_length = 30;
req = [2 2 2 2];	% Min number of [up low nums special]

% character counter
i = 1;
password = '';
up_count = 0; low_count = 0; nums_count = 0; special_count = 0;
while i <= pass_length
    % produce a random number from 1 to 4
    select = ceil((4) * rand);
    if (req(select) > 0) || ((pass_length - i + 1 - req(1) - req(2) - req(3) - req(4)) > 0)
        switch select
            % uppercase
            case 1
                password(i) = up(ceil((length(up)) * rand));
                up_count = up_count + 1;
            % lowercase
            case 2
                password(i) = low(ceil((length(low)) * rand));
                low_count = low_count + 1;
            % number
            case 3
                password(i) = nums(ceil((length(nums)) * rand));
                nums_count = nums_count + 1;
            % special character
            case 4
                password(i) = special(ceil((length(special)) * rand));
                special_count = special_count + 1;
        end
        i = i + 1;
        % if it satisfies a requirement decrement
        if (req(select) > 0)
            req(select) = req(select) - 1; 
        end
    end        
end


if (req(1) <= up_count) && (req(2) <= low_count) && (req(3) <= nums_count) && (req(4) <= special_count)
    fprintf('\nAll requirements satisfied!\n');
    fprintf('     - %d uppercase characters\n', up_count);
    fprintf('     - %d lowercase characters\n', low_count);
    fprintf('     - %d numerical characters\n', nums_count);
    fprintf('     - %d special characters\n\n', special_count);
    fprintf('The password is: %s\n\n', password);
else
    disp('One or more requirements were not satisfied!');
end