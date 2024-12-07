// @ts-check

const {test, expect, firefox} = require('@playwright/test');


test('should be able to increment counter in dynamoDB', async({request}) => {

    const firstResponse = await request.post("https://wo3npc6f78.execute-api.ap-south-1.amazonaws.com/prod/stats");
    expect(firstResponse.ok()).toBeTruthy();

    const firstResponseData = await firstResponse.json();
    const getCount = parseInt(firstResponseData.body);
    expect(getCount).toBeGreaterThanOrEqual(1);

    //second API call
    const secondResponse = await request.post("https://wo3npc6f78.execute-api.ap-south-1.amazonaws.com/prod/stats");
    expect(secondResponse.ok()).toBeTruthy();

    const secondResponseData = await secondResponse.json();
    const putCount = parseInt(secondResponseData.body);
    expect(putCount).toBeGreaterThan(getCount);
});