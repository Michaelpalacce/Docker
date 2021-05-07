<?php

if ( ! isset( $argv[1], $argv[2] ) )
{
	echo 'example usage: php -f secrets_parser.php <AWS_REGION> <SECRET_ID>' . PHP_EOL;
	exit( 1 );
}

$region			= $argv[1];
$secretId		= $argv[2];
$secretsFile	= 'secrets.json';

// Use output instead of a file
exec( "aws secretsmanager get-secret-value --secret-id {$secretId} --region {$region} --query SecretString > {$secretsFile}" );

$secrets	= file_get_contents( $secretsFile );

$secrets	= json_decode( $secrets, true );
$secrets	= json_decode( $secrets, true );

if ( ! $secrets )
{
	exit( 1 );
}

@unlink( $secretsFile );

if ( getenv( 'AS_PHP_ARRAY' ) == 1 )
{
	echo '<?php return ' . var_export( $secrets, true ) . ';';
}
else
{
	echo $secrets;
}
