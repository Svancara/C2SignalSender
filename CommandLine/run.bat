rem prepare signals_to_c2_curl.bat 
call transform.bat

rem run signals
call signals_to_c2_curl.bat

rem summarize responses to one file for review  
copy /Y c2_response_*.txt c2_responses.txt 

              