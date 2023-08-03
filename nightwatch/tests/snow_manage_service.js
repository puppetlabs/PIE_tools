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

        .assert.titleContains('Puppet Dev')
        
        // Navigate to the Service Catalog page
        .url('https://puppetdev.service-now.com/sp?id=sc_category&sys_id=2571da7f2f32201013dfc886f699b66b&catalog_id=-1')

        // Wait for the Service Catalog page to load
        .waitForElementVisible('body', 5000)

        // Make sure the link is visible in card form. this ensures the link is a h3 not a span like grid view
        .click('#tab-card')

        // Click the link
        .click('h3.catalog-item-name[title="Manage Service"]')

        // Wait for the page to load
        .waitForElementVisible('body', 5000)



        // Perform assertions or further actions as needed
        .assert.titleContains('Manage Service')

        // Select "PE Connection alias 1" from the "Puppet Server Connection" dropdown
        .click('#s2id_sp_formfield_puppet_server')
        .click('#select2-drop > ul > li:nth-child(2)')

        // Select Textbox option
        .click('#s2id_sp_formfield_select_targets')
        .click('#select2-drop > ul > li:nth-child(4)')

        // TODO: Paste fqdn from parameters instead of hardcode
        .setValue('#sp_formfield_targets', 'ip-172-31-14-133.us-east-2.compute.internal')
    
        //Fill out service status information
        .setValue('#sp_formfield_name', 'puppet')
        .click('#s2id_sp_formfield_action')
        .click('#select2-drop > ul > li:nth-child(7)')

        .click('#submit-btn')
        // End the test and close the browser
        .pause(5000)
    }
  }
