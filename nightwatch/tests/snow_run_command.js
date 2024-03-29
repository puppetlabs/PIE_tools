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

        // Navigate to the Service Catalog page
        browser.url('https://puppetdev.service-now.com/sp?id=sc_category&sys_id=2571da7f2f32201013dfc886f699b66b&catalog_id=-1')

        // Wait for the Service Catalog page to load
        .waitForElementVisible('body', 10000)

        // Click the "Run a Command" link
        browser.click('h3.catalog-item-name[title="Run a Command"]')
        // Wait for the Command page to load
        .waitForElementVisible('body', 10000)

        // Perform assertions or further actions as needed
        .assert.titleContains('Run a Command')

        // Select "PE Connection alias 1" from the "Puppet Server Connection" dropdown
        browser.click('#s2id_sp_formfield_puppet_server')
        browser.click('#select2-drop > ul > li:nth-child(2)')

        // Select node group
        browser.click('#s2id_sp_formfield_select_targets')
        browser.click('#select2-drop > ul > li:nth-child(2)')

        // select pe master node group
        browser.click('#s2id_sp_formfield_node_group')
        .setValue('#s2id_autogen3_search', 'PE Master')
        browser.click('#select2-drop > ul > li:nth-child(1)')

        //command to run
        .setValue('#sp_formfield_command', 'pwd')

        browser.click('#submit-btn')
        // End the test and close the browser
        .pause(5000)
    }
  }