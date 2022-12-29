object "ContractObject" {
    code {
        sstore(0, caller())
        datacopy(0, dataoffset("RuntimeObject"),datasize("RuntimeObject"))
        return(0x0, datasize("RuntimeObject"))
    }

    object "RuntimeObject" {

        code{
            setFreeMemoryPointer( 0x60)
            switch getSelector()
            case 0x00fdd58e /* balanceOf(address,uint256) */ {
                let ret := balanceOf(loadCallDataValue(0),loadCallDataValue(1))
                returnOneUint256(ret)
            }
            case 0x4e1273f4 /* balanceOfBatch(address[],uint256[]) */ {

            }

            case 0xa22cb465 /* setApprovalForAll(address,bool) */ {

            }

            case 0xe985e9c5 /* isApprovedForAll(address,address) */ {

            }

            case 0xf242432a /* safeTransferFrom(address,address,uint256,uint256,bytes) */ {

            }

            case 0x2eb2c2d6 /* safeBatchTransferFrom(address,address,uint256[],uint256[],bytes) */ {
                let storedLocationIndex := div(loadCallDataValue(2), 32)
                let arrayLength := loadCallDataValue(div(storedLocationIndex, 32))

                for {let y := 1} iszero(gt(y,arrayLength)) { y:= add(y,1)} {
                    debugStack(loadCallDataValue(arrayLength),loadCallDataValue(add(storedLocationIndex,y)))
                }
                //debugStack(loadCallDataValue(0),loadCallDataValue(1))
                //debugStack(loadCallDataValue(2),loadCallDataValue(3))
                //debugStack(loadCallDataValue(4),loadCallDataValue(5))
                //debugStack(loadCallDataValue(6),loadCallDataValue(7))
                //debugStack(loadCallDataValue(div(storedLocation, 32)),loadCallDataValue(0))
            }
            case 0x731133e9 /* mint(address,uint256,uint256,bytes) */ {
                let ret := mint(loadCallDataValue(0), loadCallDataValue(1), loadCallDataValue(2))
                //returnOneUint256(ret)
            }
            case 0x1f7fdffa /* mintBatch(address,uint256[],uint256[],bytes) */ {
            // todo checks

                let storedLocationIndex := div(loadCallDataValue(1), 32)
                let arrayLength := loadCallDataValue(storedLocationIndex)

                //debugStack(storedLocationIndex,arrayLength)
                //debugStack(readDynamicArrayValue(1, 1),readDynamicArrayValue(2, 1))
                //debugStack(readDynamicArrayValue(1, 2),readDynamicArrayValue(2, 2))

                //for {let y := 0} iszero(gt(y,sub(arrayLength,1))) { y:= add(y,1)} {
                    let ret := mint(loadCallDataValue(0), readDynamicArrayValue(1, 1), readDynamicArrayValue(2, 1))
                    let ret1 := mint(loadCallDataValue(0), readDynamicArrayValue(1, 2), readDynamicArrayValue(2, 2))
                    //let ret2 := balanceOf(loadCallDataValue(0),readDynamicArrayValue(1, 1))
                    let ret4 := balanceOf(loadCallDataValue(0),readDynamicArrayValue(1, 2))

                //}

            }
            case 0xf5298aca /* burn(address,uint256,uint256) */ {
                let ret := burn(loadCallDataValue(0), loadCallDataValue(1), loadCallDataValue(2))

            }
            case 0x6b20c454 /* burnBatch(address,uint256[],uint256[]) */ {

            }
            case 0x7f2c00d3 /* doSafeTransferAcceptanceCheck(address,address,address,uint256,uint256,bytes) */ {

            }
            case 0x395649f6 /* doSafeBatchTransferAcceptanceCheck(address,address,address,uint256[],uint256[],bytes) */ {

            }

            case 0x01ffc9a7 /* supportsInterface(bytes4) */ {

            }
            case 0xca160684 /*  test(uint256[]) */ {
                //mstore(0x0, 0x20)
                //mstore(0x20, 2)
                //mstore(0x40, 100)
                //mstore(0x60, 200)
                let finalPointer :=initDynamicArray(0x0, 0x80, 100)
                finalPointer := push(0x0, 5)
                return(0x0, finalPointer)

            }

            default {
                revert(0,0)
            }



            //================= Storage, Memory index functions =================================
            function getOwnerIndex() -> owner {
                owner := 0
            }
            function getFreeMemoryPointerIndex() -> idx {
                idx := 0x40
            }
            function nonceForBalanceOf() -> nonce {
                nonce := 1
            }
            function setFreeMemoryPointer(size) {
                mstore(getFreeMemoryPointerIndex(), size)
            }
            function byte32ToMemory(val) -> idx {
                let freeMemPointer := mload(getFreeMemoryPointerIndex())
                mstore(freeMemPointer, val)
                idx := add(0x20, freeMemPointer)
            }
            function byte32ToMemoryWithoutUpdatingPointer(val) -> idx {
                let freeMemPointer := mload(getFreeMemoryPointerIndex())
                mstore(freeMemPointer, val)
                idx := freeMemPointer
            }
            function byte32ToMemoryAndUpdatePointer(val) -> idx {
                let freeMemPointer := mload(getFreeMemoryPointerIndex())
                mstore(freeMemPointer, val)
                idx := add(0x20, freeMemPointer)
                mstore(getFreeMemoryPointerIndex(), idx)
            }

            //================= Util functions =================================

            /*
                Get the inital 32 bytes from the calldata and right shift it 28 bytes as the first 4 bytes represent the selector
            */
            function getSelector() -> selector {
                // 1 followed by 56 zeros
                selector :=div(calldataload(0), 0x100000000000000000000000000000000000000000000000000000000)
            }

            function returnOneUint256( value ) {
                mstore( 0x0, value)
                return (0x0,0x20)
            }

            function loadCallDataValue(offset) -> val {
                let position := add( 4, mul( offset, 0x20))
                if lt(calldatasize(), add(position, 0x20)) {
                 revert(0, 0)
                }
                val := calldataload(position)
            }

            function readDynamicArrayValue(positionInCallData, index) -> val {
                let storedLocationIndex := div(loadCallDataValue(positionInCallData), 32)
                let arrayLength := loadCallDataValue(div(storedLocationIndex, 32))

                //for {let y := 1} iszero(gt(y,arrayLength)) { y:= add(y,1)} {
                //    debugStack(loadCallDataValue(arrayLength),loadCallDataValue(add(storedLocationIndex,y)))
                //}
                //debugStack(160,loadCallDataValue(add(storedLocationIndex,index)))
                val := loadCallDataValue(add(storedLocationIndex,index))
            }

            /**
            * Use to initialize an dynamic array
            * memPointerIndex - initial index of the array which stores the memory address of the length
            * memPointerValue - this is the memory pointer address where the length of the dynamic array is stored
            * value - storing initial value
            * (finalPointer) - furthest index in memory which is used by the array
            **/

            function initDynamicArray(memPointerIndex, memPointerValue, value ) -> finalPointer {
                 if iszero(iszero(mload(memPointerIndex))) {
                    revert(0,0)
                 }
                 if iszero(iszero(mload(memPointerValue))) {
                     revert(0,0)
                 }
                mstore(memPointerIndex, memPointerValue)
                mstore(memPointerValue, 1)
                finalPointer := add(memPointerValue, 32)
                mstore(add(memPointerValue, 32), value)
                finalPointer := add(finalPointer, 32)
            }

            /**
            * memPointerIndex - initial index of the array which stores the memory address of the length
            * value - storing initial value
            * (finalPointer) - furthest index in memory which is used by the array
            **/

            function push(memPointerIndex, value) -> finalPointer {
                let memPointerValue := mload(memPointerIndex)
                let newArrayLength :=  add(mload(memPointerValue), 1)
                mstore(memPointerValue, newArrayLength)
                finalPointer := add(memPointerValue, mul(newArrayLength, 32))
                mstore(finalPointer, value)
                finalPointer := add(finalPointer, 32)

            }

            function getHashValue( attr1, attr2, attr3) -> ret{
                mstore(0x60,attr1)
                mstore(0x80,attr2)
                mstore(0xa0,attr3)
                ret := keccak256(0x60,0xc0)
            }




            //================= log functions =================================

            function emitTransferSingle(memoryStartIndex, operator, from, to, id, value){
                mstore(memoryStartIndex, id)
                mstore(add(0x20, memoryStartIndex), value)
             // ----TransferSingle(address,address,address,uint256,uint256) -----
                let signature:= 0xc3d58168c5ae7397731d063d5bbf3d657854427343f4c083240f7aacaa2d0f62
                emitLog4(memoryStartIndex, add(0x40, memoryStartIndex),signature, operator, from, to)
            }
            function emitTransferBatch(memoryStartIndex, operator, from, to, ids, values){
                //todo
                //   emitLog4(memoryStartIndex, add( 0x40, memoryStartIndex), operator, from, to)
            }
            function emitApprovalForAll(memoryStartIndex, account, operator, approved){
                mstore(memoryStartIndex, approved)
             // ----- ApprovalForAll(address,address,bool) ----------
                let signature:= 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31
                emitLog3(memoryStartIndex, add(0x20, memoryStartIndex), signature, account, operator)
            }
            function emitURI(memoryStartIndex ){
            //todo
            }
            function debugMemory(start, end) {
                log0(start, end)
            }
            function debugStack(value1, value2) {
                let signature := 0x46bd45ccd3bc364549b4235d6adb87cf5c141b730e451b8d46bdf012cdfeba30
                emitLog3(0, 0, signature, value1, value2)
            }

            function emitLog4(memoryStartIndex, memoryEndIndex, signature, t2, t3, t4){
                log4(memoryStartIndex, memoryEndIndex, signature, t2, t3, t4)
            }
            function emitLog3(memoryStartIndex, memoryEndIndex, signature, t2, t3){
                log3(memoryStartIndex, memoryEndIndex, signature, t2, t3)
            }
            function emitLog2(memoryStartIndex, memoryEndIndex, signature, t2){
                log2(memoryStartIndex, memoryEndIndex, signature, t2)
            }

            //================= logic functions =================================

            function balanceOf(addr, tokenId) -> val {
                //let freePointer := byte32ToMemoryWithoutUpdatingPointer(addr)

                //mstore(add(0x20, freePointer), tokenId)
                //mstore(add(0x40, freePointer), nonceForBalanceOf())
                //let updatedPointerValue :=  add(0x60, freePointer)
                //setFreeMemoryPointer( updatedPointerValue)
                //debugStack(freePointer,updatedPointerValue)
                //debugStack(mload(freePointer),mload(add(0x20, freePointer)))
                //debugStack(mload(add(0x40, freePointer)),mload(add(0x60, freePointer)))

                //let hash := keccak256(freePointer, updatedPointerValue)
                let hash := getHashValue(addr, tokenId, 1)
                val := sload(hash)
                debugStack(hash,val)
            }

            function mint(sender, tokenId, amount ) -> bool {
                //let freePointer := byte32ToMemoryWithoutUpdatingPointer(sender)

                //mstore(add(0x20, freePointer), tokenId)
                //mstore(add(0x40, freePointer), nonceForBalanceOf())
                //debugStack(mload(freePointer),mload(add(0x40, freePointer)))
                //let updatedPointerValue :=  add(0x60, freePointer)
                //setFreeMemoryPointer( updatedPointerValue)
                //debugStack(freePointer,updatedPointerValue)
                //debugStack(mload(freePointer),mload(add(0x20, freePointer)))
                //debugStack(mload(add(0x40, freePointer)),mload(add(0x60, freePointer)))
                //let hash := keccak256(freePointer, updatedPointerValue)
                let hash := getHashValue(sender, tokenId, 1)
                let val := sload(hash)
                //debugStack(hash,val)
                //debugStack(hash,val)
                sstore(hash, add(val, amount))
                bool := 1

            }

            function burn(sender, tokenId, amount ) -> bool {
                let freePointer := byte32ToMemoryWithoutUpdatingPointer(sender)

                mstore(add(0x20, freePointer), tokenId)
                mstore(add(0x40, freePointer), nonceForBalanceOf())
                let updatedPointerValue :=  add(0x60, freePointer)
                setFreeMemoryPointer( updatedPointerValue)

                let hash := keccak256(freePointer, updatedPointerValue)
                let val := sload(hash)
                if gt(amount, val) {
                    revert(0,0)
                }
                sstore(hash, sub(val, amount))
                bool := 1
            }


        }




    }
}