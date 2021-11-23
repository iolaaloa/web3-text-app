const main = async () => {
    const [owner, randoPerson] = await hre.ethers.getSigners();
    /*const [_, randoPerson] = await ethers.getSigners();*/
    const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther('0.1'),
    });
    await waveContract.deployed();


    console.log("Contract deployed to:", waveContract.address);
    console.log("Contract deployed by:", owner.address);
    console.log('Contract addy:', waveContract.address);

    /** Get Contract balance*/
    let contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log(
        'Contract balance:', 
    hre.ethers.utils.formatEther(contractBalance)
    );
     
    /* 
   * Let's send a few waves!
   */
    let waveTxn = await waveContract.wave('A message!');
    await waveTxn.wait(); // Wait for the transaction to be mined

    waveTxn = await waveContract.connect(randoPerson).wave('Another message!');
    await waveTxn.wait(); // Wait for the transaction to be mined

    waveTxn3 = await waveContract.connect(randoPerson).wave('Hello Wave 3');
    await waveTxn3.wait();

    contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log(
        'Contract balance:', 
    hre.ethers.utils.formatEther(contractBalance)
    );

    let waveCount;
    waveCount = await waveContract.getTotalWaves();

    waveTxn = await waveContract.wave('Its a me Mario');
    await waveTxn.wait();

    waveTxn = await waveContract.wave('This is my second wave');
    await waveTxn.wait();

    waveCount = await waveContract.getTotalWaves();

    waveCount = await waveContract.getTotalWavesForAddress(randoPerson.address);
    console.log ("current wave count for " + randoPerson.address + "is:" + waveCount);


    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);

    contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log(
        'Contract balance:', 
    hre.ethers.utils.formatEther(contractBalance)
    );

    /*let waveTxn = await waveContract.wave();
    await waveTxn.wait();
    */

   /* waveCount = await waveContract.getTotalWaves();*/


   // waveTxn = await waveContract.connect(randoPerson2).wave();
   // await waveTxn.wait();

    // waveCount = await waveContract.getTotalWaves();

    waveCount = await waveContract.getTotalWavesForAddress(randoPerson.address);
    console.log ("current wave count for " + randoPerson.address + "is:" + waveCount);

    let waveCount2 = await waveContract.getTotalWavesForAddress(owner.address);
    console.log ("current wave count for " + owner.address + "is:" + waveCount2);

    
};

  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();