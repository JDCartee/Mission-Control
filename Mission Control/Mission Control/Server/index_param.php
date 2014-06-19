<html>
<body>
<h1>It works!</h1>
<p>Now lets kick off the python script...</p> 
<?php
$output_pre=shell_exec('whoami');
echo "<pre>The server user running the script is $output_pre</pre>";
$key_param=$_GET["key"];
echo "<pre>The key value you gave me is $key_param</pre>";
$output=shell_exec("sudo /usr/bin/python /home/pi/Documents/GPIO/blink_param.py $key_param 2>&1");
<p>Here is your script output...</p>
echo "<pre>$output</pre>";
?>
</body>
</html>

