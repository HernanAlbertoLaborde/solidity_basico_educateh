// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract tc_arb{
    address payable public owner;

        struct Data{
            string date; // fecha de envio
            string delivery_date;  // fecha estimada
            string product;
            string price;
            string code; // id del proveedor
            string cel_number;
            int8 status;  // 1: en camino, 2: llego al pais, 3: en aduana, 4: entregado
            address wallet; // persona que ejecutó el contrato
        }

        Data public data;

        event newData(
            string date,
            string delivery_date,
            string product,
            string price,
            string code,
            string cel_number,
            int8 status,
            address wallet
            );
        
        // modifier para que solo el owner pueda retirar los fondos del contrato
        modifier onlyOwner(){
            require(msg.sender == owner, "Solo el propietario retira fondos");
            _;
        }

        /*
        Mofier que verifica dentro de otras funciones que al ejecutar la función
        no se tenga el valor del fee + el gass
        */
        modifier cost(uint amount){
            require(msg.value >= amount, "No tiene saldo en ARB para ejecutar");
            _;
        }

        // se define quien es el propietario.
        constructor(){
            owner = payable(msg.sender);
        }

        //función para cambiar datos del enum
        function pushData(
            string memory _date,
            string memory _delivery_date,
            string memory _product,
            string memory _price,
            string memory _code,
            string memory _cel_number,
            int8 _status) public payable cost(1000000000000000){
                data = Data(
                    _date,
                    _delivery_date,
                    _product,
                    _price,
                    _code,
                    _cel_number,
                    _status,
                    msg.sender
                );
                // logger
                emit newData(
                    _date,
                    _delivery_date,
                    _product,
                    _price,
                    _code,
                    _cel_number,
                    _status,
                    msg.sender
                );
            }

        function withdraw() public onlyOwner{
            uint balance = address(this).balance;
            require(balance > 0, "No se tienen fondos en el contrato todavia.");
            owner.transfer(balance);
        }

        // Consultar fondos que se encuentran en el contrato
        function getBalance() public view returns (uint256){
            return address(this).balance;
        }
}