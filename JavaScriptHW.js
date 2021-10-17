// 1
let salaries = {
    John: 100,
    Ann: 160,
    Pete: 130
}
let sum = salaries.John + salaries.Ann + salaries.Pete;

console.log(sum);

// 2

function multiplyNumeric(menu) {
    menu.width = 2 * menu.width;
    menu.height = 2 * menu.height;
}

let menu = {
    width: 200,
    height: 300,
    title: "My menu"
};

multiplyNumeric(menu);

console.log(menu);

// 3

function checkEmailId(str) {
    let idx1 = str.indexOf('@');
    let idx2 = str.indexOf('.');
    if (idx1 > - 1 && idx2 > -1 && idx2 - idx1 > 1) {
        return true;
    } else {
        return false;
    }
}

console.log(checkEmailId("aaaaaaaa@f.com"));

// 4

function truncate(str, maxlength) {
    let res = "";
    for (var i = 0; i < maxlength - 1; i++) {
        res += str[i];
    }
    res += str.length > maxlength ? "…": str[maxlength - 1];
    return res;
}

console.log(truncate("What I'd like to tell on this topic is:", 20));

// 5

let arr = ["James", "Brennie"];
arr.push("Robert");
arr.splice(arr.length / 2, 1, "Calvin");
console.log(arr.splice(0, 1));
arr.splice(0, 0, "Rose", "Regal");
console.log(arr);

// 6

function result() {
    this.Card = "";
    this.isVaild = false;
    this.isAllowed = false;
}

function isVaild(card) {
    let sum = 0;
    for (var i = 0; i < card.length - 1; i++) {
        sum += card[i];
    }
    return (sum * 2) % 10 == card[card.length - 1];
}

function isAllowed(card, bannedPrefixes) {
    for (var i = 0; i < bannedPrefixes.length; i++) {
        if (card.indexOf(bannedPrefixes[i]) == 0) {
            return true;
        }
    }
    return false;
}

function validateCards(cardsToValidate, bannedPrefixes) {
    let jsonResult = new Array(cardsToValidate.length);

    for (var i = 0; i < cardsToValidate.length; i++) {
        let res = new result();
        res.Card = cardsToValidate[i];
        res.isVaild = isVaild(cardsToValidate[i]);
        res.isAllowed = isAllowed(cardsToValidate[i], bannedPrefixes);
        jsonResult[i] = res;
    }

    return jsonResult;
}

console.log(validateCards(["6724843711060148", "6724843711060147", "7624843711060148", "7624843711060147"], ["11", "3434", "67248", "9"]));