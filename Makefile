all: cultuurcentrum.sol jazzathome.sol
	solc --abi --overwrite -o out/ cultuurcentrum.sol jazzathome.sol
