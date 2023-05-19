package com.example.query;

import android.os.Bundle;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import java.util.ArrayList;

import jp.co.techknowledge.dbLib;
import jp.co.techknowledge.dbLib.Row;
import jp.co.techknowledge.dbLib.status;

import android.os.Bundle;
import android.os.Handler;
import android.app.Activity;
import android.util.Log;
import android.view.Menu;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class MainActivity extends AppCompatActivity implements Runnable {

    private Handler _handler = new Handler();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        startThread();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    private void performQuery(){
        try {
            dbLib.status st;
            dbLib db = new dbLib();
            db.setRawURL(false);
            db.setVerbose(true);
            db.setURL("http://192.168.0.18:8000");		// <<==== ご利用環境に合わせて変更してください。

            st = db.connect();
            if(st == status.Normal){

                ArrayList <String> results = new ArrayList<String>();
                st = db.query("select empno,ename,job from emp");

                while(st == status.Normal){
                    //
                    Row row = db.getRow();
                    String line = "";
                    for(int j=0; j<row.columns.size(); j++){
                        String name  = row.columns.get(j).name;
                        String value = row.columns.get(j).value;
                        line += name + "=" + value + " ";
                    }
                    results.add(line);
                    st = db.fetch();
                }

                final ArrayAdapter<String> la = new ArrayAdapter<String>(this,  android.R.layout.simple_list_item_1,results);

                _handler.post(new Runnable() {
                    public void run() {
                        // set array adapter.
                        ListView lv = (ListView) findViewById(R.id.resultList);
                        lv.setAdapter(la);
                    }
                });

            }
            else {
                Log.v("test",st.toString());
            }
            db.disconnect();
        }
        catch(Exception ex){
            ex.printStackTrace();
        }

    }

    private void startThread(){
        Thread thread = new Thread(this);
        thread.start();
    }

    @Override
    public void run() {
        performQuery();
    }

}

