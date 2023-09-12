module.exports = {
    'Login and Navigate to Service Catalog': function (browser) {
        // Open the ServiceNow login page
        browser.url('https://puppetdev.service-now.com/login.do')

        // Wait for the login page to load
        .waitForElementVisible('body', 5000)

        // Enter the username and password
        .setValue('#user_name', process.env.SNOW_USERNAME)
        .setValue('#user_password', process.env.SNOW_PASS)

        // Submit the login form
        .click('#sysverb_login')

        // Wait for the home page to load after successful login
        .waitForElementVisible('body', 10000)

        console.log('GH: bing bang bong ' + process.env.SNOW_USERNAME)
        .assert.titleContains('Puppet Dev')
        
        
    }
  }
