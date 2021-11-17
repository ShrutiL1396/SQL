/*
Name:- Shruti Shivaji Lanke
Panther ID:- 002583158
Project 1 Part II: Q13 ~ Q14
*/

/*Question 13. Trigger (15%) : Create a trigger named trg_mem_balance that will
maintain the correct value in the membership balance in the MEMBERSHIP table
when videos are returned late. The trigger should execute as an AFTER trigger when
the due date or return date attributes are updated in the DETAILRENTAL table. The
Trigger should satisfy the following conditions:
a. Calculate the value of the late fee prior to the update that triggered this
execution of the trigger. The value of the late fee is the days late multiplied
by the daily late fee. If the previous value of the late fee was null, then treat it
as zero (0).
b. Calculate the value of the late fee after the update that triggered this execution
of the trigger. If the value of the late fee is now null, then treat it as zero (0).
c. Subtract the prior value of the late fee from the current value of the late fee to
determine the change in late fee for this video rental.
d. If the amount calculated in Part c is not zero (0), then update the membership
balance by the amount calculated for the membership associated with this
rental. */

DELIMITER $$
CREATE TRIGGER trg_mem_balance
AFTER UPDATE ON DETAILRENTAL
FOR EACH ROW
BEGIN
DECLARE prior_balance DECIMAL(10,2);
DECLARE updated_balance DECIMAL(10,2);
DECLARE balance_diff DECIMAL(10,2);

SET prior_balance := 
COALESCE
(OLD.detail_dailylatefee * datediff(OLD.detail_duedate,OLD.detail_returndate)
,0);
SET updated_balance := 
COALESCE(NEW.detail_dailylatefee*datediff(NEW.detail_duedate,NEW.detail_returndate)
,0);
SET balance_diff =  prior_balance - updated_balance;

IF balance_diff <> 0 THEN
UPDATE membership SET mem_balance = balance_diff + MEM_BALANCE 
WHERE mem_num = (SELECT mem_num FROM rental WHERE rental.rent_num = NEW.rent_num);
END IF;
END $$
DELIMITER ;


SELECT MEM_BALANCE FROM MEMBERSHIP WHERE MEM_NUM = '105'; -- 15.00
UPDATE DETAILRENTAL SET DETAIL_RETURNDATE = '2018-03-13' WHERE RENT_NUM = 1002;
SELECT MEM_NUM FROM RENTAL WHERE RENT_NUM = '1002';
SELECT MEM_BALANCE FROM MEMBERSHIP WHERE MEM_NUM = '105'; -- 42.00


/*
Q14.
Create a stored procedure named prc_new_rental
to insert new rows in the RENTAL table. The procedure should satisfy the following
conditions:
a. The membership number will be provided as parameter.
b. Use a count() function to verify that the membership number exits in the
MEMBERSHIP table. If it does not exist, then a message should be displayed
that the membership does not exist and no data should be written to the
database.
c. If the membership does exist, then retrieve the membership balance and
display a message that the balance is the previous balance. (e.g., if the
membership has a balance of 5.00, then display “previous balance: $ 5.00.)
d. Insert a new row in the rental table using the rent_num_seq sequence created
to generate the value for RENT_NUM, the current system date for the
RENT_DATE value, and the membership number provided as the value for
MEM_NUM.*/

/* To handle the sequence requirement */
ALTER TABLE RENTAL MODIFY COLUMN RENT_NUM INT AUTO_INCREMENT PRIMARY KEY;
ALTER TABLE RENTAL AUTO_INCREMENT=1010;

DELIMITER $$
CREATE FUNCTION GET_MEMBALANCE(P_MEM_NUM INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	DECLARE BALANCE DECIMAL(10,2);
	SELECT MEM_BALANCE INTO BALANCE FROM RENTAL INNER JOIN MEMBERSHIP ON 
	RENTAL.MEM_NUM = MEMBERSHIP.MEM_NUM WHERE RENTAL.MEM_NUM = P_MEM_NUM; 
    RETURN BALANCE;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS prc_new_rental;
DELIMITER $$
CREATE PROCEDURE prc_new_rental(in INMEM_NUM INT)
BEGIN
	DECLARE MEM_NUM_COUNT INT DEFAULT 0;
    DECLARE PREV_MEM_BALANCE DECIMAL (10,2);
    DECLARE MESSAGE VARCHAR(200) DEFAULT "";
    SELECT COUNT(*) INTO MEM_NUM_COUNT 
    FROM RENTAL
    WHERE MEM_NUM = INMEM_NUM;    
    CASE 
		WHEN MEM_NUM_COUNT = 0 THEN SET 
			MESSAGE = CONCAT('NO MEMBERSHIP WITH THE NUMBER, ', INMEM_NUM, ' EXISTS!') ;
		ELSE
			SET PREV_MEM_BALANCE = GET_MEMBALANCE(INMEM_NUM);
            SET MESSAGE = CONCAT('PREVIOUS BALANCE: $', PREV_MEM_BALANCE) ;
			INSERT INTO RENTAL(RENT_DATE,MEM_NUM)
			VALUES (NOW(),INMEM_NUM);  -- CREATE SEQUENCE */
	END CASE; 
    SELECT MESSAGE;
END $$
DELIMITER ;

CALL prc_new_rental(103);
CALL prc_new_rental(113);

SELECT * FROM RENTAL; -- to check if the procedure has successfully modified the inserted into the rental table
-- if the conditions seem suitable.
