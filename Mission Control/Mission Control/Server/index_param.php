<html>
<body>
<h1>Mission Control</h1>
<p>Now lets kick off the python script...</p>
<?php
$output_pre=shell_exec('whoami');
echo "The server user running the script is <pre>$output_pre</pre>";
$key_param=$_GET["key"];
echo "<pre>The key value you gave me is $key_param</pre>";
$output=shell_exec("sudo /usr/bin/python /home/pi/Documents/GPIO/blink_param.py$
echo "<p>Here is your script output...</p>";
echo "<pre>$output</pre>";
?>
</body>
</html>

