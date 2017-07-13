<?php
if($argc < 2){
	fprintf(STDERR, "Usage: %s [source]\n", $argv[0]);
	return 1;
}
if($argc > 2){
	$cargv = $argv;
	array_shift($cargv);
	while(($arg = array_shift($cargv)) !== NULL){
		passthru("php " . __FILE__ . " " . $arg, $code);
		if($code != 0)
			return $code;
	}
}
$source = file_get_contents($argv[1]);
if($source === FALSE){
	fprintf(STDERR, "Cannot open %s\n", $argv[1]);
	return 1;
}

if(!preg_match("/#(.*?)include.*\/glew.h(.*)/", $source)){
	return 0;
}

$firstSeenInclude = null;
$fileSz = strlen($source);
for($offset = 0; $offset < $fileSz; ){
	$eol = strpos($source, "\n", $offset);
	if($eol === FALSE){
		$eol = $fileSz;
	}
	$eol++;

	$line = substr($source, $offset, $eol - $offset);
	if(is_null($firstSeenInclude) && $line[0] == '#'){
		$firstSeenInclude = $offset;
	}

	if(preg_match("/^#(.*?)include.*\/glew.h(.*)/", $line, $m)){
		printf("[glewFirst] => Fixing %s\n", $argv[1]);
		if(is_null($firstSeenInclude)){
			//break; //it's the first include already
			$firstSeenInclude = 0;
		}

		// start of file to first include file
		$pre_include = substr($source, 0, $firstSeenInclude);
		// rest of includes until glew include
		$pre_glew = substr($source, $firstSeenInclude, $offset - $firstSeenInclude);
		// after the glew include
		$post_glew = substr($source, $eol);
		
		$newSource = $pre_include . $line . $pre_glew . $post_glew;

		file_put_contents($argv[1], $newSource);
		touch($argv[1] . ".stamp");
		break;
	}

	$offset += strlen($line);
}
return 0;
?>