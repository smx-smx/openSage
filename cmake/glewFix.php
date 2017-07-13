<?php
function rsearch($folder, $pattern) {
    $dir = new RecursiveDirectoryIterator($folder);
    $ite = new RecursiveIteratorIterator($dir);
    $files = new RegexIterator($ite, $pattern, RegexIterator::GET_MATCH);
    $fileList = array();
    foreach($files as $file) {
        $fileList = array_merge($fileList, $file);
    }
    return $fileList;
}

$path = $argv[1];
$vala_c = rsearch($path, "/.*\.c/");
foreach($vala_c as $cfile){
	$cfile = str_replace("\\", "/", $cfile);
	passthru("php " . __DIR__ . "/glewFirst.php {$cfile}", $code);
	if($code != 0)
		return $code;
}
return 0;
?>