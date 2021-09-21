<?php 
	//error_reporting(0);
	
	$dbserver = 'localhost';
	$dbuser = 'root';
	$dbpassword = '';
	$main_db = 'main_db';
	$access_key = 'your secret key';
	
	$userkey = '';
	$nickname = '';
	
	$showHTML = true;
	
	if(isset($_GET['n']))
		$nickname = trim(htmlspecialchars($_GET["n"]));

	if(isset($_GET['key']))
		$userkey = trim(htmlspecialchars($_GET["key"]));
	
	
	$conn = mysqli_connect($dbserver, $dbuser, $dbpassword, $main_db);
	
	$sql = 'CREATE TABLE IF NOT EXISTS Users(nickname text, score bigint)';
	mysqli_query($conn, $sql);
	
	if (!$conn)
		$conn = mysqli_connect($dbserver, $dbuser, $dbpassword, $main_db);
	
	if ($userkey == $access_key && $nickname != '')
	{
		$showHTML = false;
		$result = mysqli_query($conn, 'SELECT * FROM Users WHERE nickname="' . $nickname . '"');	
		if ($result && mysqli_num_rows($result) == 1) {
			$f=mysqli_fetch_array($result);
			$f[1]++;
			mysqli_query($conn, "UPDATE Users SET score=$f[1] WHERE nickname=\"$nickname\"");
			echo $f[1];
		} else {
			echo '1';
			$result = mysqli_query($conn, 'INSERT INTO Users (nickname, score) VALUES ("' . $nickname . '", 1)');	
		}
	}
?><?php if ($showHTML): ?><!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Топ очков</title>
<style type="text/css">
body{margin:0;padding:0;font-family:arial,helvetica,sans-serif;font-size:14px;}
h2{font-size:20px; text-align:center;}
a{color:#777;text-decoration:none;} 
a:hover{color:black;}
table{border-collapse: collapse;}
table td{background-color:#f9f9f9;border:1px solid #dddddd;}
table th{border:1px solid #dddddd;}
#wrapper{margin:0 auto; max-width:980px; }

table{margin:10px auto; text-align:center;}
td,th{padding:10px;}
table tr:nth-child(odd) td{background-color:white;}
</style>
</script>
</head>
<body>
	<div id="wrapper">
<?php 

	$result = mysqli_query($conn, "SELECT * FROM Users ORDER BY score DESC");
	if ($result) {
		echo '<table><tbody><tr><th>Место</th><th>Никнейм</th><th>Очки</th></tr>';
		for ($i=0; $i < mysqli_num_rows($result); $i++)
		{
			$counter = $i + 1;
			$f=mysqli_fetch_array($result);
			echo "<tr><td>$counter</td><td>$f[0]</td><td>$f[1]</td></tr>";
		}
		echo '</tbody></table>';
	}
	
	if ($conn)
		mysqli_close($conn);
?>
	</div>
</body>
</html>
<?php endif; ?>
