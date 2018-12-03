all: cultuurcentrum.sol jazzathome.sol
	solc_0.4.25 --abi --bin --overwrite -o out/ cultuurcentrum.sol jazzathome.sol
