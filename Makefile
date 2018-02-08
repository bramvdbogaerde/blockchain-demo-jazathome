all: cultuurcentrum.sol jazzathome.sol
	solc --abi --bin --overwrite -o out/ cultuurcentrum.sol jazzathome.sol
