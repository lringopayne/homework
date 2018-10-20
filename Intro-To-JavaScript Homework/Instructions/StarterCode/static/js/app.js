let tbody = d3.select("tbody");

// Getting a reference to the button on the page with the id property set to `click-me`
let button = d3.select("#filter-btn");

// Getting a reference to the input element on the page with the id property set to 'input-field'
let inputField = d3.select("#datetime");

// Function for creating table entries
function table(info) {
info.forEach((entry) => {
    var row = tbody.append("tr");
    Object.entries(entry).forEach(([key, value]) => {
      var cell = tbody.append("td");
      cell.text(value);
    });
  })
}

// Create table
table(data)

// This function is triggered when the button is clicked
function handleClick() {

    // Clear table
    tbody.html("")

    // Get the value property of the input element
    let inputValue = inputField.property("value");

    // Filter data
    let filteredData = data.filter(entry => entry.datetime === inputValue);

    // create table from filtered data
    table(filteredData)
  }

// We can use the `on` function in d3 to attach an event to the handler function
button.on("click", handleClick);